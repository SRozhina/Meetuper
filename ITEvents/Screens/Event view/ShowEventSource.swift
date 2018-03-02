import Foundation
import UIKit

class ShowEventSource: DecorationView {
    @IBOutlet weak var showSourceButton: UIButton!
    
    class func initiateAndSetup(with source: String) -> ShowEventSource {
        let showEventSourceView = UINib(nibName: "ShowEventSource", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ShowEventSource
        //TODO define source and add webview which opened link
        return showEventSourceView
    }
}
