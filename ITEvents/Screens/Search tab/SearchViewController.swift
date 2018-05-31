import UIKit
import Reusable

class SearchViewController: UIViewController, ISearchView {
    
    var presenter: ISearchPresenter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var eventCollectionViewCommon: IEventCollectionViewCommon!
    private var searchText: String { return searchBar.text ?? "" }
    private var searchTags: [Tag] = []
    
    private var events = [EventCollectionCellViewModel]() {
        didSet {
            eventCollectionViewCommon.setEvents(events)
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //TODO implement notifying about layout changes when settings are ready
        presenter.activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    private func setupViewController() {
        registerNibs()
        eventCollectionViewCommon = EventCollectionViewCommon(viewWidth: view.frame.width,
                                                              selectedEventAction: selectedEventAction,
                                                              lastCellWillDisplayAction: lastCellWillDisplayAction)
        collectionView.dataSource = eventCollectionViewCommon
        collectionView.delegate = eventCollectionViewCommon
    }
    
    func toggleLayout(value isListLayout: Bool) {
        if eventCollectionViewCommon.isListLayoutSelected == isListLayout { return }
        eventCollectionViewCommon.toggleLayout(value: isListLayout)
        collectionView.reloadData()
    }
    
    func clearEvents() {
        eventCollectionViewCommon.toggleLoadingMoreEvents(true)
        setEvents([])
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
    }
    
    func toggleProgressIndicator(shown: Bool) {
        eventCollectionViewCommon.toggleLoadingMoreEvents(shown)
        collectionView.reloadData()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: ListCollectionViewCell.self)
        collectionView.register(cellType: GridCollectionViewCell.self)
    }
    
    private func selectedEventAction(for indexPath: IndexPath) {
        presenter.selectEvent(with: events[indexPath.row].id)
        self.performSegue(withIdentifier: "Search_OpenEvent", sender: nil)
    }
    
    private func lastCellWillDisplayAction(for indexPath: IndexPath) {
        let lastEventIndex = events.count - 1
        if indexPath.row == lastEventIndex && !eventCollectionViewCommon.isLoadingMoreEvents {
            DispatchQueue.main.async {
                self.presenter.searchMoreEvents()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //remove keyboard
        
        presenter.forceEventSearching()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchEvents(by: searchText, and: searchTags)
    }
}
