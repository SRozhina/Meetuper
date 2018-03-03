import UIKit

class SharedUtils {
    static func createView<T: UIView>(nibName: String) -> T {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
    
    static func createPanelView<T: UIView>(nibName: String) -> T {
        let view = UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
        
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
