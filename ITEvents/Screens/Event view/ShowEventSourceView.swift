import Foundation
import UIKit

class ShowEventSourceView: UIView {
    @IBOutlet weak var showSourceButton: UIButton!
    
    class func initiateAndSetup(with source: EventSource, and url: URL) -> ShowEventSourceView {
        let showEventSourceView: ShowEventSourceView = SharedUtils.createPanelView(nibName: "ShowEventSourceView")
        showEventSourceView.showSourceButton.setTitle("Show on \(source.name)", for: .normal)
        return showEventSourceView
    }
}
