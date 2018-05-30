import UIKit
import Reusable

class FavoritesViewController: UIViewController, IFavoriveView {
    
    var presenter: IFavoritePresenter!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var eventCollectionViewCommon: IEventCollectionViewCommon!
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
        presenter.updateViewSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    private func setupViewController() {
        registerNibs()
        eventCollectionViewCommon = EventCollectionViewCommon(viewWidth: view.frame.width,
                                                              selectedEventAction: selectedEventAction,
                                                              lastCellWillDisplayAction: nil)
        collectionView.delegate = eventCollectionViewCommon
        collectionView.dataSource = eventCollectionViewCommon
    }
    
    private func registerNibs() {
        collectionView.register(cellType: ListCollectionViewCell.self)
        collectionView.register(cellType: GridCollectionViewCell.self)
    }
    
    func toggleLayout(value isListLayout: Bool) {
        if eventCollectionViewCommon.getLayoutState() == isListLayout { return }
        eventCollectionViewCommon.toggleLayout(value: isListLayout)
        collectionView.reloadData()
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
    }
    
    //TODO add to protocol when implement partially loading data
    func toggleProgressIndicator(shown: Bool) {
        eventCollectionViewCommon.toggleLoadingProgressState(shown)
        collectionView.reloadData()
    }
    
    private func selectedEventAction(for indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        presenter.selectEvent(with: events[indexPath.row].id)
        self.performSegue(withIdentifier: "Favorite_OpenEvent", sender: nil)
    }
}
