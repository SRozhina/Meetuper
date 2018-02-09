import UIKit

protocol IEventCollectionViewCell {
    func setTitle(_ title: String)
    func setDate(from start: Date, to end: Date)
    func setImage(_ image: UIImage)
    func setupGridLayout()
    func setupListLayout()
}
