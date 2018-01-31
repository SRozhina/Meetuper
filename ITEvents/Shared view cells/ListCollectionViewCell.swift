import UIKit
import  Foundation

class ListCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell {
    func setTitle(_ title: String) {
        eventTitleLabel.text = title
    }
    
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var eventDateLabel: UILabel!
    @IBOutlet private weak var eventBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    func commonInit() {
        eventBackgroundView.layer.cornerRadius = 14
        eventBackgroundView.clipsToBounds = true
        eventBackgroundView.layer.shadowColor = UIColor.black.cgColor
        eventBackgroundView.layer.shadowOpacity = 0.15
        eventBackgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 10)
        eventBackgroundView.layer.shadowRadius = 8
        
        eventImage.layer.cornerRadius = 14
        eventImage.clipsToBounds = true

    }
}
