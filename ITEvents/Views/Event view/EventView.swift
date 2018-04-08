import Foundation
import UIKit
import Reusable

class EventView: UIStackView, NibLoadable {
    private var sourceOpenAction: ((URL) -> Void)?
    private var event: EventViewModel!

    class func initiateAndSetup(with event: EventViewModel,
                                sourceOpenAction: ((URL) -> Void)? = nil,
                                isSimilar: Bool = false) -> EventView {
        let eventView: EventView = SharedUtils.createView()
        eventView.setup(with: event, and: sourceOpenAction, isSimilar: isSimilar)
        return eventView
    }
    
    private func setup(with event: EventViewModel,
                       and sourceOpenAction: ((URL) -> Void)?,
                       isSimilar: Bool) {
        self.event = event
        self.sourceOpenAction = sourceOpenAction
        
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
            let showEventSource = ShowEventSourceView.initiateAndSetup(with: sourceName, sourceOpenAction: openAction)
            addArrangedSubview(showEventSource)
        }
    }
    
    private func openAction() {
        if let action = sourceOpenAction, let url = event.url {
            action(url)
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
