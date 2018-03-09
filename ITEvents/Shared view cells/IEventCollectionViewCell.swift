import UIKit

protocol IEventCollectionViewCell {
    func setup(with event: Event, using dateFormatterService: IDateFormatterService)
    func setupGridLayout()
    func setupListLayout()
}
