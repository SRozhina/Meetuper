import Foundation

protocol IDateFormatterService {
    func getFormattedDateStringFrom(start: Date, end: Date, short: Bool) -> String
}
