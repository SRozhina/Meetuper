@testable import ITEvents
import Promises

class EventStorageMock: IEventsStorage {
    var events: [Event] = []
    var searchAction: ((Range<Int>) -> Cancelable<EventsResult>)?
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult> {
        if let searchAction = searchAction {
            return searchAction(indexRange)
        }
        let eventsResult = EventsResult(events: [], totalEventsCount: 0)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
}
