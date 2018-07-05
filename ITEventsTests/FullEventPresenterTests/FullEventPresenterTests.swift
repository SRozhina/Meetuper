import XCTest
@testable import ITEvents

class FullEventPresenterTests: XCTestCase {
    var presenter: IFullEventPresenter!
    var view: FullEventViewMock!
    var selectedEventService: SelectedEventServiceMock!
    var similarEventsStorage: SimilarEventsInMemoryStorage!
    var queue: DispatchQueue!
    
    override func setUp() {
        super.setUp()
        
        queue = DispatchQueue(label: "FullEventPresenterTests")
        view = FullEventViewMock()
        selectedEventService = SelectedEventServiceMock()
        let event = Event(id: 3,
                          title: "Test event",
                          dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                     end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                          address: "Большой Сампсониевский проспект 28 к2 лит Д",
                          city: "Санкт-Петербург",
                          country: "Россия",
                          description: "Description for event",
                          tags: [Tag(id: 1, name: "JavaScript")],
                          image: UIImage(named: "js")!,
                          similarEventsCount: 2,
                          source: EventSource(id: 1, name: "Timepad"),
                          url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        let similarEvents = [1, 2, 3].reduce([Int: [Event]]()) { result, number in
            var result = result
            result[number] = Array(repeating: event, count: number)
            return result
        }
        similarEventsStorage = SimilarEventsInMemoryStorage(similarEvents: similarEvents, queue: queue)
        
        presenter = FullEventPresenter(view: view,
                                       selectedEventService: selectedEventService,
                                       dateFormatterService: DateFormatterService(),
                                       similarEventsService: similarEventsStorage)
    }
    
    override func tearDown() {
        presenter = nil
        view = nil
        selectedEventService = nil
        similarEventsStorage = nil
        queue = nil
        super.tearDown()
    }
    
    func testPresenterSetupForEventWithSimilarEvents() {
        //Given
        selectedEventService.selectedEvent = Event(id: 1,
                                                   title: "Test event",
                                                   dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                                              end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                                                   address: "Большой Сампсониевский проспект 28 к2 лит Д",
                                                   city: "Санкт-Петербург",
                                                   country: "Россия",
                                                   description: "Description for event",
                                                   tags: [Tag(id: 1, name: "JavaScript")],
                                                   image: UIImage(named: "js")!,
                                                   similarEventsCount: 1,
                                                   source: EventSource(id: 1, name: "Timepad"),
                                                   url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        
        //When
        presenter.setup()
        
        //Then
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertEqual(view.showMoreEventsButtonCreated, true)
        XCTAssertEqual(view.eventsCount, 1)
        XCTAssertEqual(view.createdViewCount, 1)
    }
    
    func testPresenterSetupForEventWithoutSimilarEvents() {
        //Given
        selectedEventService.selectedEvent = Event(id: 4,
                                                   title: "Test event",
                                                   dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                                              end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                                                   address: "Большой Сампсониевский проспект 28 к2 лит Д",
                                                   city: "Санкт-Петербург",
                                                   country: "Россия",
                                                   description: "Description for event",
                                                   tags: [Tag(id: 1, name: "JavaScript")],
                                                   image: UIImage(named: "js")!,
                                                   similarEventsCount: 0,
                                                   source: EventSource(id: 1, name: "Timepad"),
                                                   url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        
        //When
        presenter.setup()
        
        //Then
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertEqual(view.showMoreEventsButtonCreated, false)
        XCTAssertEqual(view.eventsCount, 0)
        XCTAssertEqual(view.createdViewCount, 1)
    }
    
    func testPresenterGetsSimilarEvents() {
        //Given
        var isFetchedSimilarEvents = false
        let expectation = XCTestExpectation(description: "Similar events were fetched")
        selectedEventService.selectedEvent = Event(id: 2,
                                                   title: "Test event",
                                                   dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                                              end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                                                   address: "Большой Сампсониевский проспект 28 к2 лит Д",
                                                   city: "Санкт-Петербург",
                                                   country: "Россия",
                                                   description: "Description for event",
                                                   tags: [Tag(id: 1, name: "JavaScript")],
                                                   image: UIImage(named: "js")!,
                                                   similarEventsCount: 2,
                                                   source: EventSource(id: 1, name: "Timepad"),
                                                   url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        
        //When
        presenter.setup()
        presenter.requestSimilarEvents {
            expectation.fulfill()
            isFetchedSimilarEvents = true
        }
        
        //Then
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(isFetchedSimilarEvents, true)
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertEqual(view.showMoreEventsButtonCreated, true)
        XCTAssertEqual(view.eventsCount, 2)
        XCTAssertEqual(view.createdViewCount, 3)
    }
    
    func testPresenterTryToGetSimilarEventWhenTheyAreAlreadyFetched() {
        //Given
        var isFetchedSimilarEvents = false
        let expectation = XCTestExpectation(description: "Similar events were fetched")
        selectedEventService.selectedEvent = Event(id: 3,
                                                   title: "Test event",
                                                   dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                                              end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                                                   address: "Большой Сампсониевский проспект 28 к2 лит Д",
                                                   city: "Санкт-Петербург",
                                                   country: "Россия",
                                                   description: "Description for event",
                                                   tags: [Tag(id: 1, name: "JavaScript")],
                                                   image: UIImage(named: "js")!,
                                                   similarEventsCount: 3,
                                                   source: EventSource(id: 1, name: "Timepad"),
                                                   url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        
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
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertEqual(view.showMoreEventsButtonCreated, true)
        XCTAssertEqual(view.eventsCount, 3)
        XCTAssertEqual(view.createdViewCount, 4)
    }
    
    func testPresenterTryToFetchEventsWhereThereISNoSimilar() {
        //Given
        var isFetchedSimilarEvents = false
        selectedEventService.selectedEvent = Event(id: 5,
                                                   title: "Test event",
                                                   dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                                              end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                                                   address: "Большой Сампсониевский проспект 28 к2 лит Д",
                                                   city: "Санкт-Петербург",
                                                   country: "Россия",
                                                   description: "Description for event",
                                                   tags: [Tag(id: 1, name: "JavaScript")],
                                                   image: UIImage(named: "js")!,
                                                   similarEventsCount: 1,
                                                   source: EventSource(id: 1, name: "Timepad"),
                                                   url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        
        //When
        presenter.setup()
        presenter.requestSimilarEvents {
            isFetchedSimilarEvents = true
        }

        queue.sync { }
        
        //Then
        XCTAssertEqual(isFetchedSimilarEvents, false)
        XCTAssertEqual(view.eventViewCreated, true)
        XCTAssertNotEqual(view.eventsCount, 0)
        XCTAssertEqual(view.createdViewCount, 1)
    }
}
