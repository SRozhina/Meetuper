import Foundation

class FavoritePresenter : IFavoritePresenter {
    var view: IFavoriveView!
    var eventDataService: IEventsDataService!
    var dateFormatterService: IDateFormatterService!
    var selectedEventService: ISelectedEventService!

    
    func getEvents() -> [Event] {
        var events = [Event]()
        eventDataService.fetchEvents { fetchedEvents in
            events = fetchedEvents
        }
        return events
    }
}

