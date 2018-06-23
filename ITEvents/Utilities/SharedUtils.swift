import UIKit
import Reusable

class SharedUtils {
    static func createView<TView: UIView & NibLoadable>() -> TView {
        return TView.loadFromNib()
    }
    
    static func createPanelView<TView: UIView & NibLoadable>() -> TView {
        let view: TView = createView()
        SharedUtils.decorateAsPanel(view: view)
        return view
    }
    
    static func decorateAsPanel(view: UIView) {
        let layer = view.layer
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0.5, height: 10)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
}
