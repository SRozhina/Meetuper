import Foundation
import UIKit

class EventTagsView: UIView {
    class func initiateAndSetup(with tags: [Tag]) -> EventTagsView {
        let eventTagsView: EventTagsView = SharedUtils.createPanelView(nibName: "EventTagsView")
        //TODO add tags
        return eventTagsView
    }
}
