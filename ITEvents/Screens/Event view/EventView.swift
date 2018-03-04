import Foundation
import UIKit

class EventView: UIStackView {
    
    class func initiateAndSetup(with event: Event) -> EventView {
        
        let eventView: EventView = SharedUtils.createPanelView(nibName: "EventView")
        
        let eventInfo = EventInfoView.initiateAndSetup(withImage: event.image,
                                                       title: event.title,
                                                       date: "21 February, 19:00-22:00")
        
        //TODO common date description for all project
        eventView.addArrangedSubview(eventInfo)
        
        let eventPlace = EventPlaceView.initiateAndSetup(withCity: event.city,
                                                         country: event.country,
                                                         address: event.address)
        eventView.addArrangedSubview(eventPlace)
        
        let eventDescription = EventDescriptionView.initiateAndSetup(with: event.description)
        eventView.addArrangedSubview(eventDescription)
        
        let eventTags = EventTagsView.initiateAndSetup(with: event.tags)
        eventView.addArrangedSubview(eventTags)
        
        return eventView
    }
}
