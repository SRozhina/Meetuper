import Foundation
import UIKit
import Reusable

class EventDescriptionView: UIView, NibLoadable {
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    class func initiateAndSetup(with description: String) -> EventDescriptionView {
        let eventDescriptionView: EventDescriptionView = UIViewUtils.createPanelView()

        let font = UIFont.systemFont(ofSize: 15)        
        let formattedDescription = NSMutableAttributedString(html: description, with: font)
        
        eventDescriptionView.descriptionLabel.attributedText = formattedDescription
        return eventDescriptionView
    }
}
