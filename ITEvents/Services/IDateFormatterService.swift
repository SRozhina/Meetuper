import Foundation

protocol IDateFormatterService {
    func formatDate(for dateInterval: DateInterval, shortVersion: Bool) -> String
}
