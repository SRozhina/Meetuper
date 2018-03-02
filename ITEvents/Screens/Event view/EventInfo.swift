import Foundation
import UIKit

class EventInfo: DecorationView {
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    class func initiateAndSetup(withImage image: UIImage, title: String, date: String) -> EventInfo {
        let eventInfoView = UINib(nibName: "EventInfo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventInfo
        eventInfoView.imageView.image = image
        eventInfoView.titleLabel.text = title
        eventInfoView.dateLabel.text = date
        return eventInfoView
    }
}
