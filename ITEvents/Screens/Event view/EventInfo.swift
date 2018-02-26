import Foundation
import UIKit

class EventInfo: DecorationView {
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    class func initiateFromNib() -> EventInfo {
        let eventInfoView = UINib(nibName: "EventInfo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventInfo
        return eventInfoView
    }
}
