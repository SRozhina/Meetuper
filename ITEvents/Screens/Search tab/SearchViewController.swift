import UIKit
import DisplaySwitcher
import Reusable

class SearchViewController: UIViewController, ISearchView, ITabBarItemSelectable {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    var presenter: ISearchPresenter!
    private var events = [EventCollectionCellViewModel]()
    
    private var layout: DisplaySwitchLayout!
    private var layoutState: LayoutState!
    private var loadInProgress: Bool = false
    
    private var fetchEventsDebounced: ((String, Bool) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        presenter.setup()
        collectionView.addInfiniteScroll(handler: { _ in })
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
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        updateCollectionView()
    }
    
    func handleSelection() {
        presenter.activate()
        updateCollectionView()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
    
    private func fetchEvents(searchText: String, isDelayNeeded: Bool) {
        presenter.searchBy(text: searchText, tags: [])
    }
    
    private func updateCollectionView() {
        collectionView.reloadData()
        collectionView.finishInfiniteScroll()
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if loadInProgress { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadInProgress = true
            presenter.loadEventsBlock(for: searchBar.text ?? "", tags: [], then: {
                self.collectionView.reloadData()
                self.loadInProgress = false
            })
        }
    }
}
