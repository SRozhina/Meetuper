import Foundation
import UIKit

class EventView: UIStackView {
    var sourceOpenAction: ((URL) -> Void)?
    var event: Event!
    
    class func initiateAndSetup(with event: Event, sourceOpenAction: ((URL) -> Void)? = nil) -> EventView {
        let eventView: EventView = SharedUtils.createPanelView(nibName: "EventView")
        eventView.setup(with: event, and: sourceOpenAction)
        return eventView
    }
    
    private func setup(with event: Event, and sourceOpenAction: ((URL) -> Void)?) {
        self.event = event
        self.sourceOpenAction = sourceOpenAction
        
        let eventInfo = EventInfoView.initiateAndSetup(with: event.image,
                                                       title: event.title,
                                                       date: "21 February, 19:00-22:00")
        
        //TODO common date description for all project
        addArrangedSubview(eventInfo)
        
        let eventPlace = EventPlaceView.initiateAndSetup(with: event.city,
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
        if let action = sourceOpenAction, let url = event.url {
            action(url)
        }
    }
    
    func createSourceLabel() {
        let sourceLabel = EventView.createSourceLabel(text: event.source!.name)
        insertArrangedSubview(sourceLabel, at: 0)
    }
    
    private class func createSourceLabel(text: String) -> UILabel {
        let sourceLabel = UILabel()
        sourceLabel.text = "Event from \(text)"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1)
        return sourceLabel
    }
}
