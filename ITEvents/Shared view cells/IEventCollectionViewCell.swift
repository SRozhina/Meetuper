import UIKit

protocol IEventCollectionViewCell {
    func setupCellWith(_ event: Event)
    func setupGridLayout()
    func setupListLayout()
}
