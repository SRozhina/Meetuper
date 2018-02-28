import Foundation
import UIKit

class ShowEventSource: DecorationView {
    @IBOutlet weak var showSourceButton: UIButton!
    
    class func initiateAndSetup(with source: EventSource, and url: URL) -> ShowEventSource {
        let showEventSourceView = UINib(nibName: "ShowEventSource", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ShowEventSource
        showEventSourceView.showSourceButton.setTitle("Show on \(source.name)", for: .normal)
        return showEventSourceView
    }
}
