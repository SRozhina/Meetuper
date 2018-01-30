import UIKit
import DisplaySwitcher

class FavoritesViewController: UIViewController {
    let events = ["First", "Second", "Third", "Fourth", "Fiveth"]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rotationButton: SwitchLayoutButton!
    
    private var animationDuration: TimeInterval!
    private var listLayoutCellStaticHeihgt: CGFloat!
    private var gridLayoutCellStaticHeight: CGFloat!
    private var listLayout: DisplaySwitchLayout!
    private var gridLayout: DisplaySwitchLayout!
    
    private var layoutState: LayoutState = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        registerNibs()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionView()
        
    }
    
    private func setProperties() {
        animationDuration = 0.3
        listLayoutCellStaticHeihgt = 105
        gridLayoutCellStaticHeight = (view.frame.width / 2 - 20) / 0.8
        listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutCellStaticHeihgt,
                                        nextLayoutStaticCellHeight: gridLayoutCellStaticHeight,
                                        layoutState: .list)
        gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutCellStaticHeight,
                                         nextLayoutStaticCellHeight: listLayoutCellStaticHeihgt,
                                         layoutState: .grid)
    }
    
    fileprivate func setupCollectionView() {
        let layout = getCurrentLayout()
        collectionView.collectionViewLayout = layout
        setRotationButtonSelection(layout: layout)
    }
    
    private func registerNibs() {
        let listCellNib = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        collectionView.register(listCellNib, forCellWithReuseIdentifier: "ListCell")
        let gridCellNib = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        collectionView.register(gridCellNib, forCellWithReuseIdentifier: "GridCell")
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
        setRotationButtonSelection(layout: layout)
        rotationButton.animationDuration = animationDuration
    }
    
    private func getCurrentLayout() -> DisplaySwitchLayout {
        if layoutState == .list {
            return listLayout
        }
        return gridLayout
    }
    
    private func setRotationButtonSelection(layout: DisplaySwitchLayout) {
        rotationButton.isSelected = layout == listLayout
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]
        let cell: IEventCollectionViewCell & UICollectionViewCell
        switch layoutState {
        case .list:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCollectionViewCell
        case .grid:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCollectionViewCell
        }
        cell.setTitle(event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        transitionLayoutForOldLayout fromLayout: UICollectionViewLayout,
                        newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
}
