import Foundation
import UIKit

class SimilarEventsDataServiceMockImpl: ISimilarEventsDataService {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
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
                     startDate: startDate,
                     endDate: endDate,
                     address: "Большой Сампсониевский проспект 28 к2 литД",
                     city: "Санкт-Петербург",
                     country: "Россия",
                     description: """
                            19:10 - 19:40: “Svelte — «магический» фреймворк” Тим Маринин Поговорим про Svelte и подумаем зачем нам ещё один фреймворк,
                            и что это значит, что в нём нет рантайма? 19:55 - 20:25: “ES2018?” Михаил Полубояринов 23–28 января 2018 г.
                            прошел очередной митинг TC39, на котором обсуждалось то что пойдет в ES2018 и Михаилу хотелось бы поделиться с Вами
                            результатами этого митинга. 20:40 - 21:20: “рефакторинг” Алексей Золотых Рефакторинг приложения является неотъемлемой
                            частью разработки. В своем докладе я расскажу про практические аспекты этого процесса.
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
    
    func fetchSimilarEvents(for eventId: Int, then completion: @escaping ([Event]) -> Void) {
        let event2 = [createEvent(id: 2,
                                  title: "PiterCSS #25",
                                  startDate: getDateFromString(stringDate: "2018-03-31 19:00:00"),
                                  endDate: getDateFromString(stringDate: "2018-03-31 22:00:00"),
                                  image: UIImage(named: "pitercss")!,
                                  similarEventsCount: 1,
                                  source: EventSource(id: 2, name: "Meetup.com"),
                                  tags: [Tag(id: 1, name: "JavaScript"), Tag(id: 2, name: "Frontend")])]
        let event3 = [createEvent(id: 3,
                                  title: "DartUp",
                                  startDate: getDateFromString(stringDate: "2018-05-06 19:00:00"),
                                  endDate: getDateFromString(stringDate: "2018-05-06 22:00:00"),
                                  image: UIImage(named: "wrike")!,
                                  similarEventsCount: 2,
                                  source: EventSource(id: 3, name: "Meetabit"),
                                  tags: [Tag(id: 1, name: "JavaScript")]),
                      createEvent(id: 3,
                                  title: "DartUp",
                                  startDate: getDateFromString(stringDate: "2018-05-06 19:00:00"),
                                  endDate: getDateFromString(stringDate: "2018-05-06 22:00:00"),
                                  image: UIImage(named: "wrike")!,
                                  similarEventsCount: 2,
                                  source: EventSource(id: 3, name: "Meetabit"),
                                  tags: [Tag(id: 1, name: "JavaScript")])]
        let event5 = [createEvent(id: 5,
                                  title: "Yandex Frontend Meetup for Middle developers and higher",
                                  startDate: getDateFromString(stringDate: "2018-12-23 19:00:00"),
                                  endDate: getDateFromString(stringDate: "2018-12-24 22:00:00"),
                                  image: UIImage(named: "yandex")!,
                                  similarEventsCount: 1,
                                  source: EventSource(id: 1, name: "Яндекс События"),
                                  tags: [Tag(id: 1, name: "JavaScript"), Tag(id: 2, name: "Frontend")])]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if eventId == 2 {
                completion(event2)
            } else if eventId == 3 {
                completion(event3)
            } else if eventId == 5 {
                completion(event5)
            }
        }
    }
}
