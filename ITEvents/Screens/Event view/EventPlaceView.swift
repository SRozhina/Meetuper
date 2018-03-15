import Foundation
import UIKit
import Reusable

class EventPlaceView: UIView, NibLoadable {
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    class func initiateAndSetup(with city: String, country: String, address: String) -> EventPlaceView {
        let eventPlaceView: EventPlaceView = SharedUtils.createPanelView()
        eventPlaceView.setup(with: city, country: country, address: address)
        return eventPlaceView
    }
    
    private func setup(with city: String, country: String, address: String) {
        cityLabel.text = "\(city), \(country)"
        addressLabel.text = address
    }
}
