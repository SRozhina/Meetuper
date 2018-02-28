import Foundation
import UIKit

class EventView: UIStackView {
    
    class func initiateAndSetup(with event: Event) -> EventView {
        let eventView = UINib(nibName: "EventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventView
        
        let eventInfo = EventInfo.initiateAndSetup(withImage: event.image, title: event.title, date: "21 February, 19:00-22:00")
        //TODO common date description for all project
        eventView.addArrangedSubview(eventInfo)
        
        let eventPlace = EventPlace.initiateAndSetup(withCity: event.city, country: event.country, address: event.address)
        eventView.addArrangedSubview(eventPlace)
        
        let eventDescription = EventDescription.initiateAndSetup(with: event.description)
        eventView.addArrangedSubview(eventDescription)
        
        let eventTags = EventTags.initiateAndSetup(with: event.tags)
        eventView.addArrangedSubview(eventTags)
        
        return eventView
    }
}
