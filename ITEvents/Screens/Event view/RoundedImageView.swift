import Foundation
import UIKit

class RoundedImageView: UIImageView {
    init() {
        super.init(frame: CGRect.zero)
        layer.cornerRadius = 14
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 14
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 14
        clipsToBounds = true
    }
}
