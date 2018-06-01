import UIKit
import Reusable

class SearchViewController: UIViewController, ISearchView {
    
    var presenter: ISearchPresenter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var eventCollectionViewCommon: IEventCollectionViewHandler!
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
        eventCollectionViewCommon = EventCollectionViewHandler(viewWidth: view.frame.width,
                                                              collectionView: collectionView,
                                                              selectedEventAction: selectedEventAction,
                                                              lastCellWillDisplayAction: lastCellWillDisplayAction)
        collectionView.dataSource = eventCollectionViewCommon
        collectionView.delegate = eventCollectionViewCommon
    }
    
    func toggleLayout(value isListLayout: Bool) {
        if eventCollectionViewCommon.isListLayoutSelected == isListLayout { return }
        eventCollectionViewCommon.toggleListLayout()
    }
    
    func clearEvents() {
        setEvents([])
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        eventCollectionViewCommon.setEvents(events)
    }
    
    func showLoadingIndicator() {
        eventCollectionViewCommon.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        eventCollectionViewCommon.hideLoadingIndicator()
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
            self.presenter.searchMoreEvents()
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
