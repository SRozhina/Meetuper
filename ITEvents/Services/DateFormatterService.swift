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
    
    func getFormattedDateStringFrom(start: Date, end: Date, short: Bool) -> String {
        let sameDay = hasSameDay(start: start, end: end)
        let separator = sameDay ? "-" : " - "
        var currentFormatter: DateFormatter
        if short {
            currentFormatter = shortDateFormatter
        } else {
            currentFormatter = longDateFormatter
        }
        let beginDate = currentFormatter.string(from: start)
        let formatter = sameDay ? timeDateFormatter : currentFormatter
        let endDate = formatter.string(from: end)
        return "\(beginDate)\(separator)\(endDate)"
    }
    
    private func hasSameDay(start: Date, end: Date) -> Bool {
        return Calendar.current.isDate(start, equalTo: end, toGranularity: .day)
    }
}
