import UIKit
import Reusable

class ListCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell, NibReusable {
   
    @IBOutlet private weak var image: RoundedImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 14
        contentView.layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0.5, height: 10)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
    
    func setup(with event: EventCollectionCellViewModel) {
        titleLabel.text = event.title
        dateLabel.text = event.longDate
        image.image = event.image
    }
}
