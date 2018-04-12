import UIKit
import DisplaySwitcher

extension UICollectionViewDataSource {
    func getEventCollectionViewCell(_ collectionView: UICollectionView,
                                    cellForItemAt indexPath: IndexPath,
                                    event: EventCollectionCellViewModel,
                                    layoutState: LayoutState) -> UICollectionViewCell {
        //Do we really need to have full array for every cell?
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
