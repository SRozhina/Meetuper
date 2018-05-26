import UIKit

class UIGradientImageView: UIImageView {
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0.3)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.locations = [0, 0.9]
        layer.opacity = 0
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGragientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setGragientLayer()
    }
    
    func setGragientLayer(color: UIColor) {
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor,
                                color.withAlphaComponent(1).cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    
    private func setGragientLayer() {
        setGragientLayer(color: UIColor.white)
    }
    
    //TODO do we need this code? Now we have only shown or not gradient
    func setGradientOpacity(to opacity: CGFloat) {
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        gradientLayer.opacity = Float(opacity)
        CATransaction.commit()
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
}
