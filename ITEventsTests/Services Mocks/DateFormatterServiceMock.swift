@testable import ITEvents
import Foundation

class DateFormatterServiceMock: IDateFormatterService {
    func formatDate(for dateInterval: DateInterval, shortVersion: Bool) -> String {
        return "hh:mm-hh:mm dd/mm"
    }
}
