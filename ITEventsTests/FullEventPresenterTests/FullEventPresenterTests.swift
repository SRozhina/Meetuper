import XCTest
@testable import Promises
@testable import ITEvents

class FullEventPresenterTests: XCTestCase {
    var presenter: IFullEventPresenter!
    var view: FullEventViewMock!
    var selectedEventService: SelectedEventServiceMock!
    
    override func setUp() {
        super.setUp()
        
        view = FullEventViewMock()
        selectedEventService = SelectedEventServiceMock()
        
        presenter = FullEventPresenter(view: view,
                                       selectedEventService: selectedEventService,
                                       dateFormatterService: DateFormatterServiceMock(),
                                       similarEventsService: SimilarEventsStorageMock())
    }
    
    override func tearDown() {
        presenter = nil
        view = nil
        selectedEventService = nil
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
        let eventViewModel = EventViewModel(id: 1,
                                            title: "Test event",
                                            date: "hh:mm-hh:mm dd/mm",
                                            image: UIImage(named: "js")!,
                                            address: "Большой Сампсониевский проспект 28 к2 лит Д",
                                            city: "Санкт-Петербург",
                                            country: "Россия",
                                            description: "Description for event",
                                            tags: [Tag(id: 1, name: "JavaScript")],
                                            sourceName: "Timepad",
                                            url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        XCTAssertEqual(view.eventViewModel, eventViewModel)
        XCTAssertEqual(view.showMoreEventsButtonCount, 1)
        XCTAssertEqual(view.similarEventsCount, 1)
        XCTAssertEqual(view.createdViewsCount, 1)
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
        XCTAssertEqual(view.showMoreEventsButtonCount, 0)
        XCTAssertEqual(view.similarEventsCount, 0)
        XCTAssertEqual(view.createdViewsCount, 1)
    }
    
    func testPresenterGetsSimilarEvents() {
        //Given
        var isFetchedSimilarEvents = false
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
        presenter.requestSimilarEvents().then {
            isFetchedSimilarEvents = true
        }
        
        //Then
        //queue.sync { }
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(isFetchedSimilarEvents, true)
        XCTAssertEqual(view.showMoreEventsButtonCount, 1)
        XCTAssertEqual(view.similarEventsCount, 2)
        XCTAssertEqual(view.createdViewsCount, 3)
    }
    
    func testPresenterTryToGetSimilarEventWhenTheyAreAlreadyFetched() {
        //Given
        var isFetchedSimilarEvents = false
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
        presenter.requestSimilarEvents()
            .then {
                return self.presenter.requestSimilarEvents()
            }.then {
                isFetchedSimilarEvents = true
            }
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(isFetchedSimilarEvents, true)
        XCTAssertEqual(view.showMoreEventsButtonCount, 1)
        XCTAssertEqual(view.similarEventsCount, 3)
        XCTAssertEqual(view.createdViewsCount, 4)
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
        
        presenter.requestSimilarEvents().then {
            isFetchedSimilarEvents = true
        }
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(isFetchedSimilarEvents, true)
        XCTAssertEqual(view.showMoreEventsButtonCount, 1)
        XCTAssertNotEqual(view.similarEventsCount, 0)
        XCTAssertEqual(view.createdViewsCount, 1)
    }
}
