import Foundation
import UIKit

class EventPlace: DecorationView {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    class func initiateFromNib() -> EventPlace {
        let eventPlaceView = UINib(nibName: "EventPlace", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventPlace
        return eventPlaceView
    }
}
