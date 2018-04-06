import UIKit

protocol IEventCollectionViewCell {
    func setup(with event: FavoriteEventViewModel)
    func setupGridLayout()
    func setupListLayout()
}
