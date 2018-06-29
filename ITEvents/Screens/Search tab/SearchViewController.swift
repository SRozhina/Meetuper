import UIKit
import Reusable

class SearchViewController: UIViewController, ISearchView {
    
    var presenter: ISearchPresenter!

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var settingsButton: UIBarButtonItem!
    
    private var eventCollectionViewHandler: IEventCollectionViewHandler!
    private var searchText: String { return searchBar.text ?? "" }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        settingsButton.isEnabled = true
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
        eventCollectionViewHandler.toggleListLayout(value: isListLayout)
    }
    
    func clearEvents() {
        setEvents([])
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        eventCollectionViewHandler.setEvents(events)
    }
    
    func showLoadingIndicator() {
        eventCollectionViewHandler.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        eventCollectionViewHandler.hideLoadingIndicator()
    }
    
    func showBackgroundView() {
        eventCollectionViewHandler.showBackgroundView()
    }
    
    func hideBackgroundView() {
        eventCollectionViewHandler.hideBackgroundView()
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
    
    @IBAction private func showSearchParameters(_ sender: Any) {
        settingsButton.isEnabled = false
        presenter.prepareSearchParameters(completion: {
            self.performSegue(withIdentifier: "OpenSearchParameters", sender: nil)
        })
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //remove keyboard
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchEvents(by: searchText)
    }
}
