import Foundation
import UIKit
import Reusable

class ShowMoreEventsView: UIView, NibLoadable {
    @IBOutlet private weak var showMoreEventsButton: UIButton!
    
    private let notificationCenter = NotificationCenter()
    private var descriptionsCount: Int = 0
    
    var isEnable: Bool {
        get {
            return showMoreEventsButton.isEnabled
        }
        set {
            showMoreEventsButton.isEnabled = newValue
        }
    }
    
    class func initiateAndSetup(with descriptionsCount: Int, collapsed: Bool) -> ShowMoreEventsView {
        let showMoreEventsView: ShowMoreEventsView = UIViewUtils.createPanelView()
        showMoreEventsView.setup(with: descriptionsCount, collapsed: collapsed)
        return showMoreEventsView
    }
    
    private func setup(with descriptionsCount: Int, collapsed: Bool) {
        self.descriptionsCount = descriptionsCount
        self.updateTitle(for: collapsed)
    }
    
    @IBAction private func showMoreEventsTapped(_ sender: UIButton) {
        notificationCenter.post(name: .MoreEventsRequest, object: nil)
    }
    
    func addMoreEventsRequestObserver(_ observer: Any, selector: Selector) {
        notificationCenter.addObserver(observer, selector: selector, name: .MoreEventsRequest, object: nil)
    }
    
    func updateTitle(for collapsed: Bool) {
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

extension Notification.Name {
    fileprivate static let MoreEventsRequest = Notification.Name("MoreEventsRequest")
}
