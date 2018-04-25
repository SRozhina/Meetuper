import UIKit

protocol IEventCollectionViewCell {
    func setup(with event: EventCollectionCellViewModel)
    func setupGridLayout()
    func setupListLayout()
}
