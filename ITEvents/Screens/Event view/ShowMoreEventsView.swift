import Foundation
import UIKit

class ShowMoreEventsView: UIView {
    @IBOutlet private weak var showMoreEventsButton: UIButton!
    private var showOrHideEventsAction: ((@escaping () -> Void) -> Void)?
    private var descriptionsCount: Int = 0
    private var collapsed: Bool = true
    
    class func initiateAndSetup(with descriptionsCount: Int, showOrHideEventsAction: ((@escaping () -> Void) -> Void)? = nil) -> ShowMoreEventsView {
        let showMoreEventsView: ShowMoreEventsView = SharedUtils.createPanelView(nibName: "ShowMoreEventsView")
        showMoreEventsView.setup(with: descriptionsCount, action: showOrHideEventsAction)
        return showMoreEventsView
    }
    
    private func setup(with descriptionsCount: Int, action showOrHideEventsAction: ((@escaping () -> Void) -> Void)? ) {
        self.showOrHideEventsAction = showOrHideEventsAction
        self.descriptionsCount = descriptionsCount
        self.setButtonTitle()
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
        let title = ShowMoreEventsView.getButtonTitle(for: collapsed, and: descriptionsCount)
        showMoreEventsButton.setTitle(title, for: .normal)
    }
    
    private class func getButtonTitle(for collapsed: Bool, and descriptionsCount: Int) -> String {
        if collapsed {
            return descriptionsCount == 1
                ? "Show one more description"
                : "Show \(descriptionsCount) more descriptions"
        }
        return "Show less descriptions"
    }
}
