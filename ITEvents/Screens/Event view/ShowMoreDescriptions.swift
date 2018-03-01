import Foundation
import UIKit

class ShowMoreDescriptions: DecorationView {
    @IBOutlet weak var showMoreDescriptionsButton: UIButton!
    
    class func initiateAndSetup(with descriptionsCount: Int) -> ShowMoreDescriptions {
        let showMoreDescriptionsView = UINib(nibName: "ShowMoreDescriptions", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! ShowMoreDescriptions
        let buttonTitle = ShowMoreDescriptions.getDescriptionFor(hidden: true, count: descriptionsCount)
        showMoreDescriptionsView.showMoreDescriptionsButton.setTitle(buttonTitle, for: .normal)
        return showMoreDescriptionsView
    }
    
    class func getDescriptionFor(hidden: Bool, count: Int) -> String {
        if hidden {
            return count == 1 ? "Show 1 more description" : "Show \(count) more descriptions"
        } else {
            return "Show less descriptions"
        }
    }
}
