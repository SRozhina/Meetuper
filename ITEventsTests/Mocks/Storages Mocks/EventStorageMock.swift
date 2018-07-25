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
                           description: "Description for event javascript",
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
                           description: "Description for event css",
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
        var filteredEvents = events
        
        if !searchTags.isEmpty {
            filteredEvents = filteredEvents.filter {
                $0.tags.contains(where: { searchTags.contains($0) })
            }
        }
        
        if searchText != "" {
            filteredEvents = filteredEvents.filter { event in
                let lowercasedSearchText = searchText.lowercased()
                return event.title.lowercased().contains(lowercasedSearchText)
                    || event.description.lowercased().contains(lowercasedSearchText)
            }
        }
        
        let updatedIndexRange = filteredEvents.count < indexRange.upperBound
            ? indexRange.lowerBound..<filteredEvents.count
            : indexRange
        let eventsSlice = Array(filteredEvents[updatedIndexRange])
        let eventsResult = EventsResult(events: eventsSlice, totalEventsCount: filteredEvents.count)
        let promise = Promise(eventsResult)
        return Cancelable(promise: promise)
    }
}
