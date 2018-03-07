import Foundation
import UIKit

class ShowEventSourceView: UIView {
    @IBOutlet private var showSourceButton: UIButton!
    var sourceOpenAction: (() -> Void)?
    
    class func initiateAndSetup(with text: String, sourceOpenAction: (() -> Void)? = nil) -> ShowEventSourceView {
        let showEventSourceView: ShowEventSourceView = SharedUtils.createPanelView(nibName: "ShowEventSourceView")
        showEventSourceView.sourceOpenAction = sourceOpenAction
        showEventSourceView.showSourceButton.setTitle("Show on \(text)", for: .normal)
        return showEventSourceView
    }
    
    @IBAction private func showEventSourceTapped(_ sender: UIButton) {
        if let action = sourceOpenAction {
            action()
        }
    }
}
 
