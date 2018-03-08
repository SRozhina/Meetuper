import Foundation

protocol IDateFormatterService {
    func getFormattedDateStringFrom(dateInterval: DateInterval, short: Bool) -> String
}
