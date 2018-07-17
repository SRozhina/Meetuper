@testable import ITEvents
import Promises

class EventStorageMock: IEventsStorage {
    var events: [Event] = []
    
    init(events: [Event] = []) {
        if !events.isEmpty {
            self.events = events
            return
        }
        let event1 = Event(id: 1,
                           title: "Test event1",
                           dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                      end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                           address: "Большой Сампсониевский проспект 28 к2 лит Д",
                           city: "Санкт-Петербург",
                           country: "Россия",
                           description: "Description for event",
                           tags: [Tag(id: 1, name: "JavaScript")],
                           image: UIImage(named: "js")!,
                           similarEventsCount: 2,
                           source: EventSource(id: 1, name: "Timepad"),
                           url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        let event2 = Event(id: 2,
                           title: "Test event2",
                           dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                      end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                           address: "Большой Сампсониевский проспект 28 к2 лит Д",
                           city: "Санкт-Петербург",
                           country: "Россия",
                           description: "Description for event",
                           tags: [Tag(id: 1, name: "JavaScript"), Tag(id: 1, name: "CSS")],
                           image: UIImage(named: "js")!,
                           similarEventsCount: 2,
                           source: EventSource(id: 1, name: "Timepad"),
                           url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        for _ in Array(1..<10) {
            self.events.append(contentsOf: [event1, event2])
        }
    }
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult> {
        let updatedIndexRange = events.count < indexRange.upperBound
            ? indexRange.lowerBound..<events.count
            : indexRange
        let eventsSlice = Array(events[updatedIndexRange])
        let eventsResult = EventsResult(events: eventsSlice, totalEventsCount: events.count)
        let promise = Promise(eventsResult)
        return Cancelable(promise: promise)
    }
}
