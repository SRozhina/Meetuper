import UIKit

protocol IEventCollectionViewCell {
    func setTitle(_ title: String)
    func setDate(_ date: String) //TODO: Replace String -> Date
    func setImage(_ image: UIImage)
    func setupGridLayout()
    func setupListLayout()
}
