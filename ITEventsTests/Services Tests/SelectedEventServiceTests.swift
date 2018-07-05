import XCTest
@testable import ITEvents

class SelectedEventServiceTests: XCTestCase {
    var selectedEventService: ISelectedEventService!
    
    override func setUp() {
        super.setUp()
        selectedEventService = SelectedEventService()
    }

    override func tearDown() {
        super.tearDown()
        selectedEventService = nil
    }

    func testSavingSelectedEvent() {
        //Given
        let event = Event(id: 1,
                          title: "Test event",
                          dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                     end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                          address: "Большой Сампсониевский проспект 28 к2 литД",
                          city: "Санкт-Петербург",
                          country: "Россия",
                          description: "Description for event",
                          tags: [Tag(id: 1, name: "JavaScript")],
                          image: UIImage(named: "js")!,
                          similarEventsCount: 0,
                          source: EventSource(id: 1, name: "Timepad"),
                          url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        
        //When
        selectedEventService.selectedEvent = event
        
        //Then
        XCTAssertNotNil(selectedEventService.selectedEvent)
        XCTAssertEqual(selectedEventService.selectedEvent, event)
    }
}
