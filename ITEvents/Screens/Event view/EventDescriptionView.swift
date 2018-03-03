import Foundation
import UIKit

class EventDescriptionView: UIView {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func initiateAndSetup(with description: String) -> EventDescriptionView {
        let eventDescriptionView: EventDescriptionView = SharedUtils.createPanelView(nibName: "EventDescriptionView")
        eventDescriptionView.descriptionLabel.text = description
        return eventDescriptionView
    }
    
    //TODO make text formatted from html https://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
}
