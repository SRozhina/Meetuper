import Foundation
import UIKit

class EventPlace: DecorationView {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    class func initiateAndSetup(withCity city: String, country: String, address: String) -> EventPlace {
        let eventPlaceView = UINib(nibName: "EventPlace", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventPlace
        //eventPlaceView.cityLabel.text = "\(city), \(country)"
        //eventPlaceView.addressLabel.text = address
        return eventPlaceView
    }
}
