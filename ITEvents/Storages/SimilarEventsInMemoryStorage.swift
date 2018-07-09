import UIKit
import Promises

class SimilarEventsInMemoryStorage: ISimilarEventsStorage {
    private var similarEventsById: [Int: [Event]] = [:]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    init() {
        similarEventsById = [
            2: [
                createEvent(id: 2,
                            title: "PiterCSS #25",
                            startDate: parseDate(stringDate: "2018-03-31 19:00:00"),
                            endDate: parseDate(stringDate: "2018-03-31 22:00:00"),
                            image: UIImage(named: "pitercss")!,
                            similarEventsCount: 1,
                            source: EventSource(id: 2, name: "Meetup.com"),
                            tags: [
                                Tag(id: 1, name: "JavaScript"),
                                Tag(id: 2, name: "Frontend")
                    ]
                )
            ],
            3: [
                createEvent(id: 3,
                            title: "DartUp",
                            startDate: parseDate(stringDate: "2018-05-06 19:00:00"),
                            endDate: parseDate(stringDate: "2018-05-06 22:00:00"),
                            image: UIImage(named: "wrike")!,
                            similarEventsCount: 2,
                            source: EventSource(id: 3, name: "Meetabit"),
                            tags: [Tag(id: 1, name: "JavaScript")]
                ),
                createEvent(id: 3,
                            title: "DartUp",
                            startDate: parseDate(stringDate: "2018-05-06 19:00:00"),
                            endDate: parseDate(stringDate: "2018-05-06 22:00:00"),
                            image: UIImage(named: "wrike")!,
                            similarEventsCount: 2,
                            source: EventSource(id: 3, name: "Meetabit"),
                            tags: [Tag(id: 1, name: "JavaScript")]
                )
            ],
            5: [
                Event(id: 5,
                      title: "Yandex Frontend Meetup for Middle developers and higher",
                      dateInterval: DateInterval(start: parseDate(stringDate: "2018-12-23 19:00:00"),
                                                 end: parseDate(stringDate: "2018-12-24 22:00:00")),
                      address: "Большой Сампсониевский проспект 28 к2 литД",
                      city: "Санкт-Петербург",
                      country: "Россия",
                      description: "Short description for iPad",
                      tags: [
                        Tag(id: 1, name: "JavaScript"),
                        Tag(id: 2, name: "Frontend")
                    ],
                      image: UIImage(named: "yandex")!,
                      similarEventsCount: 1,
                      source: EventSource(id: 1, name: "Яндекс События"),
                      url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
            ]
        ]
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
    
    private func parseDate(stringDate: String) -> Date {
        return dateFormatter.date(from: stringDate)!
    }
    
    func fetchSimilarEvents(for eventId: Int) -> Promise<[Event]> {
        let pendingPromise = Promise<[Event]>.pending()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let events = self.similarEventsById[eventId] ?? []
            pendingPromise.fulfill(events)
        }
        return pendingPromise
    }
}
