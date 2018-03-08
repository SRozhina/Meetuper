import Foundation

class DateFormatterService: IDateFormatterService {
    private let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter
    }()
    
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm"
        return formatter
    }()
    
    private let timeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func getFormattedDateStringFrom(dateInterval: DateInterval, short: Bool) -> String {
        let sameDay = hasSameDay(dateInterval: dateInterval)
        let separator = sameDay ? "-" : " - "
        var currentFormatter: DateFormatter
        if short {
            currentFormatter = shortDateFormatter
        } else {
            currentFormatter = longDateFormatter
        }
        let beginDate = currentFormatter.string(from: dateInterval.start)
        let formatter = sameDay ? timeDateFormatter : currentFormatter
        let endDate = formatter.string(from: dateInterval.end)
        return "\(beginDate)\(separator)\(endDate)"
    }
    
    private func hasSameDay(dateInterval: DateInterval) -> Bool {
        return Calendar.current.isDate(dateInterval.start, equalTo: dateInterval.end, toGranularity: .day)
    }
}
