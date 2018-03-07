import Foundation
import UIKit

class EventInfoView: UIView {
    @IBOutlet private weak var imageView: RoundedImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    class func initiateAndSetup(withImage image: UIImage, title: String, date: String) -> EventInfoView {
        let eventInfoView: EventInfoView = SharedUtils.createPanelView(nibName: "EventInfoView")
        eventInfoView.imageView.image = image
        eventInfoView.titleLabel.text = title
        eventInfoView.dateLabel.text = date
        return eventInfoView
    }
}
