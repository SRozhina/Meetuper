import UIKit
import DisplaySwitcher

class FavoritesViewController: UIViewController {
    let list = ["First", "Second", "Third", "Fourth", "Fiveth"]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rotationButton: UIBarButtonItem!
    
    private let animationDuration: TimeInterval = 0.3
    private let listLayoutCellStaticHeihgt: CGFloat = 80
    private let gridLayoutCellStaticHeight: CGFloat = 165
    
    private lazy var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutCellStaticHeihgt,
                                                      nextLayoutStaticCellHeight: gridLayoutCellStaticHeight,
                                                      layoutState: .list)
    private lazy var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutCellStaticHeight,
                                                      nextLayoutStaticCellHeight: listLayoutCellStaticHeihgt,
                                                      layoutState: .grid)
    
    private var layoutState: LayoutState = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = getCurrentLayout()
    }
    
    @IBAction func changeLayout(_ sender: Any) {
        if layoutState == .list {
            layoutState = .grid
        } else {
            layoutState = .list
        }
        let transitionManager = TransitionManager(duration: animationDuration,
                                                  collectionView: collectionView,
                                                  destinationLayout: getCurrentLayout(),
                                                  layoutState: layoutState)
        transitionManager.startInteractiveTransition()
    }
    
    private func getCurrentLayout() -> DisplaySwitchLayout {
        if layoutState == .list {
            return listLayout
        }
        return gridLayout
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCollectionViewCell
        cell.eventTitleLabel.text = list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        transitionLayoutForOldLayout fromLayout: UICollectionViewLayout,
                        newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
}
