import UIKit

class GridCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell {
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventImage: UIGradientImageView!
    @IBOutlet private weak var eventDateLabel: UILabel!
    @IBOutlet private weak var eventBackgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func setTitle(_ title: String) {
        eventTitleLabel.text = title
    }
    
    func commonInit() {
        eventBackgroundView.layer.cornerRadius = 14
        eventBackgroundView.clipsToBounds = true
        shadowView.layer.cornerRadius = 14
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.10
        shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 10)
        shadowView.layer.shadowRadius = 8
    }
}
