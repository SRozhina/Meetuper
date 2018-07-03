import XCTest
@testable import ITEvents

class FullEventPresenterTests: XCTestCase {
    var presenter: IFullEventPresenter!
    var view: (IFullEventView & IFullEventViewMock)!
    var selectedEventService: ISelectedEventService!
    
    override func setUp() {
        super.setUp()
        
        view = FullEventViewMock()
        selectedEventService = SelectedEventService()
        let dateFormatterService = DateFormatterService()
        
        let similarEventsStorage = SimilarEventsInMemoryStorage()
        
        presenter = FullEventPresenter(view: view,
                                       selectedEventService: selectedEventService,
                                       dateFormatterService: dateFormatterService,
                                       similarEventsService: similarEventsStorage)
    }
    
    override func tearDown() {
        presenter = nil
        view = nil
        selectedEventService = nil
        super.tearDown()
    }
    
    func testPresenterSetupForEventWithSimilarEvents() {
        //Given
        let event = Event(id: 3,
                          title: "Test event",
                          dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                     end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                          address: "Большой Сампсониевский проспект 28 к2 литД",
                          city: "Санкт-Петербург",
                          country: "Россия",
                          description: "Description for event",
                          tags: [Tag(id: 1, name: "JavaScript")],
                          image: UIImage(named: "js")!,
                          similarEventsCount: 2,
                          source: EventSource(id: 1, name: "Timepad"),
                          url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        selectedEventService.selectedEvent = event
        
        //When
        presenter.setup()
        
        //Then
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertEqual(view.showMoreEventsButtonCreated, true)
    }
    
    func testPresenterSetupForEventWithoutSimilarEvents() {
        //Given
        let event = Event(id: 3,
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
        selectedEventService.selectedEvent = event
        
        //When
        presenter.setup()
        
        //Then
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertEqual(view.showMoreEventsButtonCreated, false)
    }
    
    func testPresenterGetsSimilarEvents() {
        //Given
        var isFetchedSimilarEvents = false
        let expectation = XCTestExpectation(description: "Similar events were fetched")
        let event = Event(id: 3,
                          title: "Test event",
                          dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                     end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                          address: "Большой Сампсониевский проспект 28 к2 литД",
                          city: "Санкт-Петербург",
                          country: "Россия",
                          description: "Description for event",
                          tags: [Tag(id: 1, name: "JavaScript")],
                          image: UIImage(named: "js")!,
                          similarEventsCount: 2,
                          source: EventSource(id: 1, name: "Timepad"),
                          url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        selectedEventService.selectedEvent = event
        
        //When
        presenter.setup()
        presenter.requestSimilarEvents {
            expectation.fulfill()
            isFetchedSimilarEvents = true
        }
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(isFetchedSimilarEvents, true)
    }
    
    func testPresenterTryToGetSimilarEventWhenTheyAreAlreadyFetched() {
        //Given
        var isFetchedSimilarEvents = false
        let expectation = XCTestExpectation(description: "Similar events were fetched")
        let event = Event(id: 3,
                          title: "Test event",
                          dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                     end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                          address: "Большой Сампсониевский проспект 28 к2 литД",
                          city: "Санкт-Петербург",
                          country: "Россия",
                          description: "Description for event",
                          tags: [Tag(id: 1, name: "JavaScript")],
                          image: UIImage(named: "js")!,
                          similarEventsCount: 2,
                          source: EventSource(id: 1, name: "Timepad"),
                          url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        selectedEventService.selectedEvent = event
        
        //When
        presenter.setup()
        presenter.requestSimilarEvents {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        presenter.requestSimilarEvents {
            isFetchedSimilarEvents = true
        }
        
        //Then
        XCTAssertEqual(isFetchedSimilarEvents, true)
    }
}
