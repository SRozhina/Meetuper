import Foundation
import UIKit

class EventDataServiceMockImpl: IEventDataService {
    private func createEvent(title: String, startDate: Date, endDate: Date, image: UIImage) -> Event {
        return Event(title: title,
                     startDate: startDate,
                     endDate: endDate,
                     place: "",
                     city: "",
                     description: "",
                     tags: [],
                     image: image)
    }
    
    private func getDateFromString(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: stringDate)!
    }
    
    func fetchEvents() -> [Event] {
        let events = [
            createEvent(title: "PiterJS #21",
                        startDate: getDateFromString(stringDate: "2018-01-18 19:00:00"),
                        endDate: getDateFromString(stringDate: "2018-01-18 22:00:00"),
                        image: UIImage(named: "js")!),
            createEvent(title: "PiterCSS #25",
                        startDate: getDateFromString(stringDate: "2018-03-31 19:00:00"),
                        endDate: getDateFromString(stringDate: "2018-03-31 22:00:00"),
                        image: UIImage(named: "pitercss")!),
            createEvent(title: "DartUp",
                        startDate: getDateFromString(stringDate: "2018-05-06 19:00:00"),
                        endDate: getDateFromString(stringDate: "2018-05-06 22:00:00"),
                        image: UIImage(named: "wrike")!),
            createEvent(title: "EmberJS",
                        startDate: getDateFromString(stringDate: "2018-09-09 19:00:00"),
                        endDate: getDateFromString(stringDate: "2018-09-09 22:00:00"),
                        image: UIImage(named: "ember")!),
            createEvent(title: "Yandex Frontend Meetup for Middle developers and higher",
                        startDate: getDateFromString(stringDate: "2018-12-23 19:00:00"),
                        endDate: getDateFromString(stringDate: "2018-12-24 22:00:00"),
                        image: UIImage(named: "yandex")!)
        ]
        return events
    }
}
