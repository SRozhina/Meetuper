import Foundation
import UIKit

class EventDescription: DecorationView {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func initiateAndSetup(with description: String) -> EventDescription {
        let eventDescriptionView = UINib(nibName: "EventDescription", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventDescription
        eventDescriptionView.descriptionLabel.text = description
        return eventDescriptionView
    }
    
    //TODO make text formatted from html https://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
}
