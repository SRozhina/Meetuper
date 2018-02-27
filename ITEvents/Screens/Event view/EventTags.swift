import Foundation
import UIKit

class EventTags: DecorationView {
    class func initiateAndSetup(with tags: [Tag]) -> EventTags {
        let eventTagsView = UINib(nibName: "EventTags", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventTags
        //TODO add tags
        return eventTagsView
    }
}
