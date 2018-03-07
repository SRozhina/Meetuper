import Foundation
import UIKit

class ShowEventSourceView: UIView {
    @IBOutlet private var showSourceButton: UIButton!
    var sourceOpenAction: (() -> Void)?
    
    class func initiateAndSetup(with text: String, sourceOpenAction: (() -> Void)? = nil) -> ShowEventSourceView {
        let showEventSourceView: ShowEventSourceView = SharedUtils.createPanelView(nibName: "ShowEventSourceView")
        showEventSourceView.setup(with: text, and: sourceOpenAction)
        return showEventSourceView
    }
    
    private func setup(with text: String, and action: (() -> Void)? = nil) {
        self.sourceOpenAction = action
        self.showSourceButton.setTitle("Show on \(text)", for: .normal)
    }
    
    @IBAction private func showEventSourceTapped(_ sender: UIButton) {
        if let action = sourceOpenAction {
            action()
        }
    }
}
 
