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
    
    func formatDate(for dateInterval: DateInterval, shortVersion: Bool) -> String {
        let sameDay = hasSameDay(dateInterval: dateInterval)
        let separator = sameDay ? "-" : " - "
        
        let beginDateFormatter = getBeginDateFormatter(short: shortVersion)
        let endDateFormatter = getEndDateFormatter(sameDay: sameDay, beginDateFormatter: beginDateFormatter)
        
        let beginDate = beginDateFormatter.string(from: dateInterval.start)
        let endDate = endDateFormatter.string(from: dateInterval.end)
        
        return "\(beginDate)\(separator)\(endDate)"
    }
    
    private func getBeginDateFormatter(short: Bool) -> DateFormatter {
        return short ? shortDateFormatter : longDateFormatter
    }
    
    private func getEndDateFormatter(sameDay: Bool, beginDateFormatter: DateFormatter) -> DateFormatter {
        return sameDay ? timeDateFormatter : beginDateFormatter
    }
    
    private func hasSameDay(dateInterval: DateInterval) -> Bool {
        return Calendar.current.isDate(dateInterval.start, equalTo: dateInterval.end, toGranularity: .day)
    }
}
