import UIKit
import DisplaySwitcher
import Reusable

class SearchViewController: UIViewController, ISearchView, ITabBarItemSelectable {
    var presenter: ISearchPresenter!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicatorViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var events = [EventCollectionCellViewModel]()
    private var layout: DisplaySwitchLayout!
    private var layoutState: LayoutState!
    private var loadInProgress: Bool = false
    
    private var fetchEventsDebounced: ((String, Bool) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        fetchEventsDebounced = debounce(
            delay: DispatchTimeInterval.seconds(2),
            queue: DispatchQueue.main,
            action: fetchEvents
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    func toggleLayout(for isList: Bool) {
        layout = createDisplaySwitcherLayout(forList: isList, viewWidth: view.frame.width)
        collectionView.collectionViewLayout = layout
        layoutState = isList ? .list : .grid
    }
    
    func setEvents(_ fetchedEvents: [EventCollectionCellViewModel]) {
        self.events = fetchedEvents
        collectionView.reloadData()
        collectionView.contentOffset.y = 0
    }
    
    func insertEvents(_ fetchedEvents: [EventCollectionCellViewModel], at indexes: [Int]) {
        events.append(contentsOf: fetchedEvents)
        let indexPaths = indexes.map { IndexPath(row: $0, section: 0)}
        collectionView.insertItems(at: indexPaths)
    }
    
    func handleSelection() {
        presenter.activate()
        collectionView.reloadData()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
    
    private func fetchEvents(searchText: String, isDelayNeeded: Bool) {
        presenter.loadEventsBlock(for: searchText, tags: [], isAdditional: false, then: nil)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getEventCollectionViewCell(collectionView,
                                          cellForItemAt: indexPath,
                                          event: events[indexPath.row],
                                          layoutState: layoutState)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        presenter.selectEvent(with: events[indexPath.row].id)
        self.performSegue(withIdentifier: "Search_OpenEvent", sender: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        fetchEventsDebounced(searchText, false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchEventsDebounced(searchText, true)
    }
}

extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loadInProgress { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            toggleActivityIndicator(visibility: true)
            presenter.loadEventsBlock(for: searchBar.text ?? "", tags: [], isAdditional: true, then: {
                self.toggleActivityIndicator(visibility: false)
            })
        }
    }
    
    private func toggleActivityIndicator(visibility: Bool) {
        let height: CGFloat = visibility ? 40 : 0
        visibility ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) {
            self.activityIndicatorViewHeight.constant = height
            self.view.layoutSubviews()
            if !visibility {
                self.collectionView.contentOffset.y += 40
            }
        }
        loadInProgress = visibility
    }
}
