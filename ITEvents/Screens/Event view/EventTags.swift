import Foundation
import UIKit

class EventTags: DecorationView {
    class func initiateFromNib() -> EventTags {
        let eventTagsView = UINib(nibName: "EventTags", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventTags
        return eventTagsView
    }
}
