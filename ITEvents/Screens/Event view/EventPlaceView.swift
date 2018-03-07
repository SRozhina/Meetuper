import Foundation
import UIKit

class EventPlaceView: UIView {
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    class func initiateAndSetup(withCity city: String, country: String, address: String) -> EventPlaceView {
        let eventPlaceView: EventPlaceView = SharedUtils.createPanelView(nibName: "EventPlaceView")
        eventPlaceView.cityLabel.text = "\(city), \(country)"
        eventPlaceView.addressLabel.text = address
        return eventPlaceView
    }
}
