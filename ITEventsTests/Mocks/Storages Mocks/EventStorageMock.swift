@testable import ITEvents
import Promises

class EventStorageMock: IEventsStorage {
    var searchEventsMocked: ((Range<Int>) -> Cancelable<EventsResult>)?
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult> {
        if let searchEventsMocked = searchEventsMocked {
            return searchEventsMocked(indexRange)
        }
        let eventsResult = EventsResult(events: [], totalEventsCount: 0)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
}
