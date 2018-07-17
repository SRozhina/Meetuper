import Foundation
import UIKit
import Reusable

class EventView: UIStackView, NibLoadable {
    private var event: EventViewModel!
    private var eventURLOpener: IEventURLOpener!

    class func initiateAndSetup(with event: EventViewModel,
                                eventURLOpener: IEventURLOpener,
                                isSimilar: Bool = false) -> EventView {
        let eventView: EventView = UIViewUtils.createView()
        eventView.setup(with: event, eventURLOpener: eventURLOpener, isSimilar: isSimilar)
        return eventView
    }
    
    private func setup(with event: EventViewModel,
                       eventURLOpener: IEventURLOpener,
                       isSimilar: Bool) {
        self.event = event
        self.eventURLOpener = eventURLOpener
        
        if isSimilar {
            let sourceLabel = EventView.createSourceLabel(text: event.sourceName!)
            addArrangedSubview(sourceLabel)
        }

        let eventInfo = EventInfoView.initiateAndSetup(with: event.image,
                                                       title: event.title,
                                                       date: event.date)
        addArrangedSubview(eventInfo)
        
        let eventPlace = EventPlaceView.initiateAndSetup(with: event.city,
                                                         country: event.country,
                                                         address: event.address)
        addArrangedSubview(eventPlace)
        
        let eventDescription = EventDescriptionView.initiateAndSetup(with: event.description)
        addArrangedSubview(eventDescription)
        
        let eventTags = EventTagsView.initiateAndSetup(with: event.tags)
        addArrangedSubview(eventTags)
        
        if let sourceName = event.sourceName {
            let showEventSource = ShowEventSourceView.initiateAndSetup(with: sourceName)
            showEventSource.addShowEventSourceObserver(self, selector: #selector(openAction))
            addArrangedSubview(showEventSource)
        }
    }
    
    @objc
    private func openAction() {
        if let url = event.url {
            eventURLOpener.open(url: url)
        }
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
