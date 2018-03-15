import UIKit
import Reusable

class SharedUtils {
    static func createView<T: UIView & NibLoadable>() -> T {
        return T.loadFromNib()
    }
    
    static func createPanelView<T: UIView & NibLoadable>() -> T {
        let view = T.loadFromNib()
        SharedUtils.decorateAsPanel(view: view)
        return view
    }
    
    private static func decorateAsPanel(view: UIView) {
        let layer = view.layer
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0.5, height: 10)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
}
