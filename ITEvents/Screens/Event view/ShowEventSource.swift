import Foundation
import UIKit

class ShowEventSourceView: UIView {
    @IBOutlet weak var showSourceButton: UIButton!
    
    class func initiateAndSetup(with source: String) -> ShowEventSourceView {
        let showEventSourceView: ShowEventSourceView = SharedUtils.createPanelView(nibName: "ShowEventSourceView")
        //TODO define source and add webview which opened link
        return showEventSourceView
    }
}
