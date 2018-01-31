import UIKit

class UIGradientImageView: UIImageView {
    let myGradientLayer: CAGradientLayer

    override init(frame: CGRect) {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        myGradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        myGradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        myGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        let color = UIColor.white
        myGradientLayer.colors = [color.withAlphaComponent(0).cgColor,
                                  color.withAlphaComponent(1).cgColor]
        myGradientLayer.locations = [0, 0.9]
        self.layer.addSublayer(myGradientLayer)
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        myGradientLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
}
