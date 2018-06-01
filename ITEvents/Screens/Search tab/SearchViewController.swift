import UIKit
import Reusable

class SearchViewController: UIViewController, ISearchView {
    
    var presenter: ISearchPresenter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var eventCollectionViewHandler: IEventCollectionViewHandler!
    private var searchText: String { return searchBar.text ?? "" }
    private var searchTags: [Tag] = []
    
    private var events = [EventCollectionCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    private func setupViewController() {
        registerNibs()
        eventCollectionViewHandler = EventCollectionViewHandler(viewWidth: view.frame.width,
                                                              collectionView: collectionView,
                                                              selectedEventAction: selectedEventAction,
                                                              lastCellWillDisplayAction: lastCellWillDisplayAction)
        collectionView.dataSource = eventCollectionViewHandler
        collectionView.delegate = eventCollectionViewHandler
    }
    
    func toggleLayout(value isListLayout: Bool) {
        if eventCollectionViewHandler.isListLayoutSelected == isListLayout { return }
        eventCollectionViewHandler.toggleListLayout()
    }
    
    func clearEvents() {
        setEvents([])
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        eventCollectionViewHandler.setEvents(events)
    }
    
    func showLoadingIndicator() {
        eventCollectionViewHandler.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        eventCollectionViewHandler.hideLoadingIndicator()
    }
    
    private func registerNibs() {
        collectionView.register(cellType: ListCollectionViewCell.self)
        collectionView.register(cellType: GridCollectionViewCell.self)
    }
    
    private func selectedEventAction(for event: EventCollectionCellViewModel) {
        collectionView.isUserInteractionEnabled = false
        presenter.selectEvent(with: event.id)
        self.performSegue(withIdentifier: "OpenEvent", sender: nil)
    }
    
    private func lastCellWillDisplayAction() {
        DispatchQueue.main.async {
            self.presenter.loadMoreEvents()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //remove keyboard
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchEvents(by: searchText, and: searchTags)
    }
}
