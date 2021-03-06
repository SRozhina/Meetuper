import Foundation
import Promises

class EventsInMemoryStorage: IEventsStorage {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    func searchEvents(indexRange: Range<Int>, searchText: String, searchTags: [Tag]) -> Cancelable<EventsResult> {
        let pendingPromise = Promise<EventsResult>.pending()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let events = self.getEvents()
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
            let filteredEventsSlice = Array(filteredEvents[updatedIndexRange])
            let filteredEventsResult = EventsResult(events: filteredEventsSlice, totalEventsCount: filteredEvents.count)
            pendingPromise.fulfill(filteredEventsResult)
        }
        
        return Cancelable<EventsResult>(promise: pendingPromise)
    }
    
    private func createEvent(id: Int,
                             title: String,
                             startDate: Date,
                             endDate: Date,
                             image: UIImage,
                             similarEventsCount: Int,
                             source: EventSource,
                             tags: [Tag]) -> Event {
        return Event(id: id,
                     title: title,
                     dateInterval: DateInterval(start: startDate, end: endDate),
                     address: "Большой Сампсониевский проспект 28 к2 литД",
                     city: "Санкт-Петербург",
                     country: "Россия",
                     description: """
                            <ul><li><b>19:10 - 19:40</b>: “Svelte — «магический» фреймворк” Тим Маринин<br />
                            Поговорим про Svelte и подумаем зачем нам ещё один фреймворк, и что это значит, что в нём нет рантайма?</li>
                            <li><b>19:55 - 20:25</b>: “ES2018?” Михаил Полубояринов<br />
                            23–28 января 2018 г. прошел очередной митинг TC39, на котором обсуждалось то что пойдет в
                            ES2018 и Михаилу хотелось бы поделиться с Вами результатами этого митинга.</li>
                            <li><b>20:40 - 21:20</b>: “рефакторинг” Алексей Золотых<br />
                            Рефакторинг приложения является неотъемлемой частью разработки. В своем докладе я
                            расскажу про практические аспекты этого процесса.</li></ul>
                            """,
                     tags: tags,
                     image: image,
                     similarEventsCount: similarEventsCount,
                     source: source,
                     url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
    }
    
    private func getDateFromString(stringDate: String) -> Date {
        return dateFormatter.date(from: stringDate)!
    }
    
    private func getEvents() -> [Event] {
        var events = [Event]()
        for _ in 0..<10 {
            events.append(contentsOf:
            [
                createEvent(id: 1,
                            title: "PiterJS #21",
                            startDate: getDateFromString(stringDate: "2018-01-18 19:00:00"),
                            endDate: getDateFromString(stringDate: "2018-01-18 22:00:00"),
                            image: UIImage(named: "js")!,
                            similarEventsCount: 0,
                            source: EventSource(id: 1, name: "Timepad"),
                            tags: [Tag(id: 1, name: "JavaScript")]
                ),
                createEvent(id: 2,
                            title: "PiterCSS #25",
                            startDate: getDateFromString(stringDate: "2018-03-31 19:00:00"),
                            endDate: getDateFromString(stringDate: "2018-03-31 22:00:00"),
                            image: UIImage(named: "pitercss")!,
                            similarEventsCount: 1,
                            source: EventSource(id: 2, name: "Meetup.com"),
                            tags: [
                                Tag(id: 7, name: "CSS"),
                                Tag(id: 9, name: "Frontend")
                    ]),
                createEvent(id: 3,
                            title: "DartUp",
                            startDate: getDateFromString(stringDate: "2018-05-06 19:00:00"),
                            endDate: getDateFromString(stringDate: "2018-05-06 22:00:00"),
                            image: UIImage(named: "wrike")!,
                            similarEventsCount: 2,
                            source: EventSource(id: 3, name: "Meetabit"),
                            tags: [Tag(id: 6, name: "Dart")]),
                createEvent(id: 4,
                            title: "EmberJS",
                            startDate: getDateFromString(stringDate: "2018-09-09 19:00:00"),
                            endDate: getDateFromString(stringDate: "2018-09-09 22:00:00"),
                            image: UIImage(named: "ember")!,
                            similarEventsCount: 0,
                            source: EventSource(id: 1, name: "Timepad"),
                            tags: [Tag(id: 1, name: "JavaScript")]),
                Event(id: 5,
                      title: "Yandex Frontend Meetup for Middle developers and higher",
                      dateInterval: DateInterval(start: getDateFromString(stringDate: "2018-12-23 19:00:00"),
                                                 end: getDateFromString(stringDate: "2018-12-24 22:00:00")),
                      address: "Большой Сампсониевский проспект 28 к2 литД",
                      city: "Санкт-Петербург",
                      country: "Россия",
                      description: "Short description for iPad",
                      tags: [
                        Tag(id: 1, name: "JavaScript"),
                        Tag(id: 9, name: "Frontend")
                    ],
                      image: UIImage(named: "yandex")!,
                      similarEventsCount: 1,
                      source: EventSource(id: 1, name: "Яндекс События"),
                      url: URL(string: "https://pitercss.timepad.ru/event/457262/")),
                createEvent(id: 6,
                            title: "DagistanCSS",
                            startDate: getDateFromString(stringDate: "2011-09-09 19:00:00"),
                            endDate: getDateFromString(stringDate: "2011-09-09 22:00:00"),
                            image: UIImage(named: "ember")!,
                            similarEventsCount: 0,
                            source: EventSource(id: 1, name: "Timepad"),
                            tags: [Tag(id: 7, name: "CSS")])
            ])
        }
        return events
    }
}
