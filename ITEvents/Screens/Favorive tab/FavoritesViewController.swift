import UIKit
import DisplaySwitcher
import Reusable

class FavoritesViewController: UIViewController, IFavoriveView {
    var presenter: IFavoritePresenter!
    var dateFormatterService: IDateFormatterService!
    private var events = [Event]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var rotationButton: SwitchLayoutButton!
    
    private var animationDuration: TimeInterval = 0.3
    private var listLayout: DisplaySwitchLayout!
    private var gridLayout: DisplaySwitchLayout!
    
    private var layoutState: LayoutState!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup(then: { self.collectionView.reloadData() })
        setUpLayouts()
        setupCollectionView()
        rotationButton.animationDuration = animationDuration
        registerNibs()
    }
    
    func setEvents(_ events: [Event]) {
        self.events = events
    }
    
    private func setUpLayouts() {
        let listLayoutCellStaticHeihgt: CGFloat = 85
        let gridLayoutCellStaticHeight: CGFloat = 190
        let gridColumnCount = floor(view.frame.width / 168)
        listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutCellStaticHeihgt,
                                         nextLayoutStaticCellHeight: gridLayoutCellStaticHeight,
                                         layoutState: .list,
                                         cellPadding: CGPoint(x: 10, y: 8))
        gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutCellStaticHeight,
                                         nextLayoutStaticCellHeight: listLayoutCellStaticHeihgt,
                                         layoutState: .grid,
                                         cellPadding: CGPoint(x: 10, y: 8),
                                         gridLayoutCountOfColumns: Int(gridColumnCount))
    }
    
    private func setupCollectionView() {
        let layout = getCurrentLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
    
    @IBAction func changeLayout(_ sender: Any) {
        presenter.changeLayoutState()
        let layout = getCurrentLayout()
        let transitionManager = TransitionManager(duration: animationDuration,
                                                  collectionView: collectionView,
                                                  destinationLayout: layout,
                                                  layoutState: layoutState)
        transitionManager.startInteractiveTransition()
    }
    
    func setLayoutState(to value: Bool) {
        self.layoutState = value ? .list : .grid
    }
    
    private func getCurrentLayout() -> DisplaySwitchLayout {
        return layoutState == .list ? listLayout : gridLayout
    }
    
    func setButtonRotation(to value: Bool) {
        rotationButton.isSelected = value
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if layoutState == .list {
            cell.setupListLayout()
        } else {
            cell.setupGridLayout()
        }
        cell.setup(with: event, using: dateFormatterService)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        transitionLayoutForOldLayout fromLayout: UICollectionViewLayout,
                        newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.isUserInteractionEnabled = false
        presenter.selectEvent(events[indexPath.row])
        self.performSegue(withIdentifier: "Favorite_OpenEvent", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isUserInteractionEnabled = true
    }
}
