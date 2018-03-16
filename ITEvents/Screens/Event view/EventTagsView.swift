import Foundation
import UIKit
import Reusable

class EventTagsView: UIView, NibLoadable {
    class func initiateAndSetup(with tags: [Tag]) -> EventTagsView {
        let eventTagsView: EventTagsView = SharedUtils.createPanelView()
        //TODO add tags
        return eventTagsView
    }
}
