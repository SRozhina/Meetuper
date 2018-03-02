import Foundation
import UIKit

class EventDescription: DecorationView {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func initiateAndSetup(with description: String) -> EventDescription {
        let eventDescriptionView = UINib(nibName: "EventDescription", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventDescription
        let attributedString = try? NSAttributedString(htmlString: description,
                                                       font: UIFont.systemFont(ofSize: 15),
                                                       useDocumentFontSize: false)
        eventDescriptionView.descriptionLabel.attributedText = attributedString ?? NSAttributedString(string: description)
        return eventDescriptionView
    }
}
