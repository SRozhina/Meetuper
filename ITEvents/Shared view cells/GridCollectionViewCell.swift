import UIKit

//extension UIImageView {
//    func addGradient() {
//        let gradient = CAGradientLayer()
//        gradient.frame = self.frame
//        let whiteColor = UIColor.green
//        gradient.colors = [whiteColor.withAlphaComponent(0).cgColor, whiteColor.withAlphaComponent(1).cgColor]
//        gradient.locations = [0, 1]
//        self.layer.addSublayer(gradient)
//    }
//}

class GridCollectionViewCell: UICollectionViewCell, IEventCollectionViewCell {
    func setTitle(_ title: String) {
        eventTitleLabel.text = title
    }
    
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var eventDateLabel: UILabel!
    @IBOutlet private weak var eventBackgroundView: UIView!
    //var gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //commonInit()
    }
//
//    func commonInit() {
//        //var view = UIView(frame: eventBackgroundView.frame)
//
//
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = CGPoint(x: 0, y: 1)
//        let whiteColor = UIColor.green
//        gradient.colors = [whiteColor.withAlphaComponent(0).cgColor, whiteColor.withAlphaComponent(1).cgColor]
//        gradient.locations = [0, 1]
//        //gradient.frame = view.frame
//        //view.layer.insertSublayer(gradient, at: 0)
//        //eventImage.layer.insertSublayer(gradient, at: 0)
//
//        eventImage.layer.addSublayer(gradient)
//        //eventImage.bringSubview(toFront: view)
//
//        //eventImage.layer.mask = mask
//        //setNeedsLayout()
//
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.gradient.frame = self.frame
//    }
}
