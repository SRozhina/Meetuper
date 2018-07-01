import XCTest
@testable import ITEvents

class DateFormatterServiceTests: XCTestCase {
    var dateFormatterService: DateFormatterService!
    var dateIntervalSameDate: DateInterval!
    var dateIntervalDifferentDates: DateInterval!
    
    override func setUp() {
        super.setUp()
        
        dateFormatterService = DateFormatterService()

        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter
        }()
        
        let startDate = "2018-01-18 19:00:00"
        let endDate = "2018-01-18 22:00:00"
        let endDifferentDate = "2018-01-19 22:00:00"
        
        dateIntervalSameDate = DateInterval(start: dateFormatter.date(from: startDate)! ,
                                            end: dateFormatter.date(from: endDate)!)
        dateIntervalDifferentDates = DateInterval(start: dateFormatter.date(from: startDate)!,
                                                  end: dateFormatter.date(from: endDifferentDate)!)
    }
    
    override func tearDown() {
        dateFormatterService = nil
    }
    
    func testShortDateSameDay() {
        let formattedDate = dateFormatterService.formatDate(for: dateIntervalSameDate, shortVersion: true)
        XCTAssertEqual(formattedDate, "18 Jan 19:00-22:00")
    }
    
    func testShortDateDifferentsDays() {
        let formattedDate = dateFormatterService.formatDate(for: dateIntervalDifferentDates, shortVersion: true)
        XCTAssertEqual(formattedDate, "18 Jan 19:00 - 19 Jan 22:00")
    }
    
    func testLongDateSameDay() {
        let formattedDate = dateFormatterService.formatDate(for: dateIntervalSameDate, shortVersion: false)
        XCTAssertEqual(formattedDate, "18 January 19:00-22:00")
    }
    
    func testLongDateDifferentsDays() {
        let formattedDate = dateFormatterService.formatDate(for: dateIntervalDifferentDates, shortVersion: false)
        XCTAssertEqual(formattedDate, "18 January 19:00 - 19 January 22:00")
    }
}
