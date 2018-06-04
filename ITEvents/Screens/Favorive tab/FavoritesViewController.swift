import UIKit
import Reusable

class FavoritesViewController: UIViewController, IFavoriveView {
    
    var presenter: IFavoritePresenter!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var eventCollectionViewHandler: IEventCollectionViewHandler!
    
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
        collectionView.delegate = eventCollectionViewHandler
        collectionView.dataSource = eventCollectionViewHandler
    }
    
    private func registerNibs() {
        collectionView.register(cellType: ListCollectionViewCell.self)
        collectionView.register(cellType: GridCollectionViewCell.self)
    }
    
    func toggleLayout(value isListLayout: Bool) {
        eventCollectionViewHandler.toggleListLayout(value: isListLayout)
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
