@testable import ITEvents
import Foundation
import Promises
import UIKit

class SimilarEventsStorageMock: ISimilarEventsStorage {
    var similarEventsById: [Int: [Event]] = [:]
    
    init() {
        let event = Event(id: 3,
                          title: "Test event",
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
        similarEventsById = [1, 2, 3].reduce([Int: [Event]]()) { result, number in
            var result = result
            result[number] = Array(repeating: event, count: number)
            return result
        }
    }
    
    func fetchSimilarEvents(for eventId: Int) -> Promise<[Event]> {
        let events = self.similarEventsById[eventId] ?? []
        return Promise(events)
    }
}
