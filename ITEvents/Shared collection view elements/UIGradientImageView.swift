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
    
    func setGragientLayer(color: UIColor = .white, opacity: Float = 0) {
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor,
                                color.withAlphaComponent(1).cgColor]
        gradientLayer.opacity = opacity
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
}
