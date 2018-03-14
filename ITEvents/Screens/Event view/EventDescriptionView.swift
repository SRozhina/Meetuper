import Foundation
import UIKit

class EventDescriptionView: UIView {
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    class func initiateAndSetup(with description: String) -> EventDescriptionView {
        let eventDescriptionView: EventDescriptionView = SharedUtils.createPanelView(nibName: "EventDescriptionView")

        let font = UIFont.systemFont(ofSize: 15)
        let formattedDescription = NSMutableAttributedString.create(html: description, with: font)
        eventDescriptionView.descriptionLabel.attributedText = formattedDescription
        return eventDescriptionView
    }
}
