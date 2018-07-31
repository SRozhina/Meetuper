@testable import ITEvents
import Promises

class EventStorageMock: IEventsStorage {
    var searchEventsMocked: ((Range<Int>) -> Cancelable<EventsResult>)!
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult> {
        return searchEventsMocked(indexRange)
    }
}
