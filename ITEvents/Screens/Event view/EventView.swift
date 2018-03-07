import Foundation
import UIKit

class EventView: UIStackView {
    var sourceOpenAction: ((URL) -> Void)?
    var event: Event?
    
    class func initiateAndSetup(with event: Event, sourceOpenAction: ((URL) -> Void)? = nil) -> EventView {
        let eventView: EventView = SharedUtils.createPanelView(nibName: "EventView")
        eventView.sourceOpenAction = sourceOpenAction
        eventView.setup(with: event)
        return eventView
    }
    
    private func setup(with event: Event?) {
        guard let event = event else { return }
        
        self.event = event
        
        let eventInfo = EventInfoView.initiateAndSetup(withImage: event.image,
                                                       title: event.title,
                                                       date: "21 February, 19:00-22:00")
        
        //TODO common date description for all project
        addArrangedSubview(eventInfo)
        
        let eventPlace = EventPlaceView.initiateAndSetup(withCity: event.city,
                                                         country: event.country,
                                                         address: event.address)
        addArrangedSubview(eventPlace)
        
        let eventDescription = EventDescriptionView.initiateAndSetup(with: event.description)
        addArrangedSubview(eventDescription)
        
        let eventTags = EventTagsView.initiateAndSetup(with: event.tags)
        addArrangedSubview(eventTags)
        
        if let source = event.source {
            let showEventSource = ShowEventSourceView.initiateAndSetup(with: source.name, sourceOpenAction: openAction)
            addArrangedSubview(showEventSource)
        }
    }
    
    private func openAction() {
        if let action = sourceOpenAction, let event = event {
            action(event.url!)
        }
    }
}
