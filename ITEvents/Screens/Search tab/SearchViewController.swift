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

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
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
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        collectionView.reloadData()
    }
    
    func handleSelection() {
        presenter.activate()
        collectionView.reloadData()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
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
        let searchTags = [Tag]()
        presenter.searchEvents(by: searchText, and: searchTags, isDelayNeeded: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchEvents(by: searchText, and: [], isDelayNeeded: true)
    }
}

extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loadInProgress { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.size.height {
            toggleActivityIndicator(visibility: true)
            presenter.loadEventsBlock(for: searchBar.text ?? "", tags: [], then: {
                self.toggleActivityIndicator(visibility: false)
                self.collectionView.reloadData()
            })
        }
    }
    
    private func toggleActivityIndicator(visibility: Bool) {
        let height: CGFloat = visibility ? 40 : 0
        visibility ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2) {
            self.activityIndicatorViewHeight.constant = height
            self.view.layoutSubviews()
        }
        loadInProgress = visibility
    }
}
