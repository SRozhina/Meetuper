import UIKit

class UIGradientImageView: UIImageView {
    let gradientLayer: CAGradientLayer = { 
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0.3)
        layer.endPoint = CGPoint(x: 0, y: 1)
        let color = UIColor.white
        layer.colors = [color.withAlphaComponent(0).cgColor,
                        color.withAlphaComponent(1).cgColor]
        layer.locations = [0, 0.9]
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.addSublayer(gradientLayer)
    }
    
    func showGradient() {
        gradientLayer.opacity = 1
    }
    
    func hideGradient() {
        gradientLayer.opacity = 0
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
}
