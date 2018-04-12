import UIKit
import DisplaySwitcher
import Reusable

class FavoritesViewController: UIViewController, IFavoriveView {
    var presenter: IFavoritePresenter!
    private var events = [EventCollectionCellViewModel]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var rotationButton: SwitchLayoutButton!
    
    private var animationDuration: TimeInterval = 0.3
    private var listLayout: DisplaySwitchLayout!
    private var gridLayout: DisplaySwitchLayout!
    
    private var layoutState: LayoutState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayouts()
        rotationButton.animationDuration = animationDuration
        registerNibs()
        
        presenter.setup()
        
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
    
    func setEvents(_ events: [EventCollectionCellViewModel]) {
        self.events = events
        collectionView.reloadData()
    }
    
    func toggleListLayout(to list: Bool) {
        layoutState = list ? .list : .grid
        rotationButton.isSelected = list
    }
    
    private func setUpLayouts() {
        let viewWidth = view.frame.width
        listLayout = createDisplaySwitcherLayout(forList: true, viewWidth: viewWidth)
        gridLayout = createDisplaySwitcherLayout(forList: false, viewWidth: viewWidth)
    }
    
    private func setupCollectionView() {
        let layout = getCurrentLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
    
    @IBAction private func changeLayout(_ sender: Any) {
        presenter.toggleLayoutState()
        let layout = getCurrentLayout()
        let transitionManager = TransitionManager(duration: animationDuration,
                                                  collectionView: collectionView,
                                                  destinationLayout: layout,
                                                  layoutState: layoutState)
        transitionManager.startInteractiveTransition()
    }
    
    private func getCurrentLayout() -> DisplaySwitchLayout {
        return layoutState == .list ? listLayout : gridLayout
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getEventCollectionViewCell(collectionView,
                                          cellForItemAt: indexPath,
                                          event: events[indexPath.row],
                                          layoutState: layoutState)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        transitionLayoutForOldLayout fromLayout: UICollectionViewLayout,
                        newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        presenter.selectEvent(with: events[indexPath.row].id)
        self.performSegue(withIdentifier: "Favorite_OpenEvent", sender: nil)
    }
}
