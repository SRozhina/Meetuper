import Foundation
import UIKit
import Reusable

class ShowEventSourceView: UIView, NibLoadable {
    @IBOutlet private var showSourceButton: UIButton!
    private var sourceOpenAction: (() -> Void)?
    
    class func initiateAndSetup(with text: String, sourceOpenAction: (() -> Void)? = nil) -> ShowEventSourceView {
        let showEventSourceView: ShowEventSourceView = UIViewUtils.createPanelView()
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
 
