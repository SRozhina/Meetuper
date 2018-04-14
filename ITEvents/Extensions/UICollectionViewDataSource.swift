import UIKit
import DisplaySwitcher

extension UICollectionViewDataSource {
    func getEventCollectionViewCell(_ collectionView: UICollectionView,
                                    cellForItemAt indexPath: IndexPath,
                                    event: EventCollectionCellViewModel,
                                    layoutState: LayoutState) -> UICollectionViewCell {
        let cell: EventCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if layoutState == .list {
            cell.setupListLayout()
        } else {
            cell.setupGridLayout()
        }
        cell.setup(with: event)
        return cell
    }
}
