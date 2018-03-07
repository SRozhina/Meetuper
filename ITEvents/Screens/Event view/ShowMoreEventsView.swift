import Foundation
import UIKit

class ShowMoreEventsView: UIView {
    @IBOutlet private weak var showMoreEventsButton: UIButton!
    var showOrHideEventsAction: ((@escaping () -> Void) -> Void)?
    private var descriptionsCount: Int = 0
    private var collapsed: Bool = true
    
    class func initiateAndSetup(with descriptionsCount: Int, showOrHideEventsAction: ((@escaping () -> Void) -> Void)? = nil) -> ShowMoreEventsView {
        let showMoreEventsView: ShowMoreEventsView = SharedUtils.createPanelView(nibName: "ShowMoreEventsView")
        showMoreEventsView.showOrHideEventsAction = showOrHideEventsAction
        showMoreEventsView.descriptionsCount = descriptionsCount
        showMoreEventsView.setButtonTitle()
        return showMoreEventsView
    }
    
    @IBAction private func showMoreEventsTapped(_ sender: UIButton) {
        if let action = showOrHideEventsAction {
            sender.isEnabled = false
            action {
                self.collapsed = !self.collapsed
                self.setButtonTitle()
                sender.isEnabled = true
            }
        }
    }
    
    private func setButtonTitle() {
        var title = ""
        if collapsed {
            title = descriptionsCount == 1
                ? "Show one more description"
                : "Show \(descriptionsCount) more descriptions"
        } else {
            title = "Show less descriptions"
        }
        showMoreEventsButton.setTitle(title, for: .normal)
    }
}
