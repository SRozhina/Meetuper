import Foundation
import UIKit

class ShowMoreEventsView: UIView {
    @IBOutlet weak var showMoreEventsButton: UIButton!
    
    class func initiateAndSetup(with descriptionsCount: Int) -> ShowMoreEventsView {
        let showMoreEventsView: ShowMoreEventsView = SharedUtils.createPanelView(nibName: "ShowMoreEventsView")
        let buttonTitle = ShowMoreEventsView.getDescriptionFor(hidden: true, count: descriptionsCount)
        showMoreEventsView.showMoreEventsButton.setTitle(buttonTitle, for: .normal)
        return showMoreEventsView
    }
    
    class func getDescriptionFor(hidden: Bool, count: Int) -> String {
        if hidden {
            return count == 1
                ? "Show one more description"
                : "Show \(count) more descriptions"
        }
        return "Show less descriptions"
    }
}
