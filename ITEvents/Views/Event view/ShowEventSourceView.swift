import Foundation
import UIKit
import Reusable

class ShowEventSourceView: UIView, NibLoadable {
    @IBOutlet private var showSourceButton: UIButton!
    private var notificationCenter = NotificationCenter()
    
    class func initiateAndSetup(with text: String) -> ShowEventSourceView {
        let showEventSourceView: ShowEventSourceView = UIViewUtils.createPanelView()
        showEventSourceView.setup(with: text)
        return showEventSourceView
    }
    
    private func setup(with text: String) {
        self.showSourceButton.setTitle("Show on \(text)", for: .normal)
    }
    
    @IBAction private func showEventSourceTapped(_ sender: UIButton) {
        notificationCenter.post(name: .ShowEventSource, object: nil)
    }
    
    public func addShowEventSourceObserver(_ observer: Any, selector: Selector) {
        notificationCenter.addObserver(observer, selector: selector, name: .ShowEventSource, object: nil)
    }
}

extension Notification.Name {
    fileprivate static let ShowEventSource = Notification.Name("ShowEventSource")
}
