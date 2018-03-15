import UIKit
import DisplaySwitcher
import Reusable

class FavoritesViewController: UIViewController {
    var eventDataService: IEventsDataService!
    var dateFormatterService: IDateFormatterService!
    private var events = [Event]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var rotationButton: SwitchLayoutButton!
    
    private var animationDuration: TimeInterval!
    private var listLayout: DisplaySwitchLayout!
    private var gridLayout: DisplaySwitchLayout!
    
    private var layoutState: LayoutState = .list
    
    private var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDataService.fetchEvents { fetchedEvents in
            self.events = fetchedEvents
            self.collectionView.reloadData()
        }
        setProperties()
        registerNibs()
        setupCollectionView()
        rotationButton.animationDuration = animationDuration
    }
    
    private func setProperties() {
        animationDuration = 0.3
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
        setButtonRotation(for: layout)
    }
    
    private func registerNibs() {
        collectionView.register(cellType: EventCollectionViewCell.self)
    }
    
    @IBAction func changeLayout(_ sender: Any) {
        if layoutState == .list {
            layoutState = .grid
        } else {
            layoutState = .list
        }
        let layout = getCurrentLayout()
        let transitionManager = TransitionManager(duration: animationDuration,
                                                  collectionView: collectionView,
                                                  destinationLayout: layout,
                                                  layoutState: layoutState)
        transitionManager.startInteractiveTransition()
        setButtonRotation(for: layout)
    }
    
    private func getCurrentLayout() -> DisplaySwitchLayout {
        return layoutState == .list ? listLayout : gridLayout
    }
    
    private func setButtonRotation(for layout: DisplaySwitchLayout) {
        rotationButton.isSelected = layout == listLayout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let fullEventView = segue.destination as? FullEventViewController {
            fullEventView.event = selectedEvent
        }
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        switch layoutState {
        case .list:
            cell.setupListLayout()
        case .grid:
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
        selectedEvent = events[indexPath.row]
        self.performSegue(withIdentifier: "Favorite_OpenEvent", sender: nil)
    }
}
