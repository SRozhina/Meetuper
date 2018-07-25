@testable import ITEvents
import Promises

class EventStorageMock: IEventsStorage {
    var events: [Event] = []
    var searchAction: ((Range<Int>, String, [Tag]) -> Cancelable<EventsResult>)?
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult> {
        if let searchAction = searchAction {
            return searchAction(indexRange, searchText, searchTags)
        }
        let eventsResult = EventsResult(events: [], totalEventsCount: 0)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
}
