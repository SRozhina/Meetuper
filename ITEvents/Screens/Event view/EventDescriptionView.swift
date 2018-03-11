import Foundation
import UIKit

class EventDescriptionView: UIView {
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    class func initiateAndSetup(with description: String) -> EventDescriptionView {
        let eventDescriptionView: EventDescriptionView = SharedUtils.createPanelView(nibName: "EventDescriptionView")
        let attributedString = try? NSAttributedString(htmlString: description,
                                                       font: UIFont.systemFont(ofSize: 15),
                                                       useDocumentFontSize: false)
        eventDescriptionView.descriptionLabel.attributedText = attributedString ?? NSAttributedString(string: description)
        return eventDescriptionView
    }
}
