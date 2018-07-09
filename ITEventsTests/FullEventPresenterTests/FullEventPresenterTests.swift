import XCTest
@testable import Promises
@testable import ITEvents

class FullEventPresenterTests: XCTestCase {
    private var presenter: IFullEventPresenter!
    private var viewMock: FullEventViewMock!
    private var selectedEventServiceMock: SelectedEventServiceMock!
    
    override func setUp() {
        super.setUp()
        
        viewMock = FullEventViewMock()
        selectedEventServiceMock = SelectedEventServiceMock()
        
        presenter = FullEventPresenter(view: viewMock,
                                       selectedEventService: selectedEventServiceMock,
                                       dateFormatterService: DateFormatterServiceMock(),
                                       similarEventsService: SimilarEventsStorageMock())
    }
    
    override func tearDown() {
        presenter = nil
        viewMock = nil
        selectedEventServiceMock = nil
        super.tearDown()
    }
    
    func testPresenterSetupForEventWithSimilarEvents() {
        //Given
        selectedEventServiceMock.selectedEvent = Event(id: 1,
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
        let expectedEventViewModel = EventViewModel(id: 1,
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
        XCTAssertEqual(viewMock.eventViewModel, expectedEventViewModel)
        XCTAssertEqual(viewMock.showMoreEventsButtonCount, 1)
        XCTAssertEqual(viewMock.similarEventsViewsCount, 0)
        XCTAssertEqual(viewMock.createdViewsCount, 1)
    }
    
    func testPresenterSetupForEventWithoutSimilarEvents() {
        //Given
        selectedEventServiceMock.selectedEvent = Event(id: 4,
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
        XCTAssertEqual(viewMock.showMoreEventsButtonCount, 0)
        XCTAssertEqual(viewMock.similarEventsViewsCount, 0)
        XCTAssertEqual(viewMock.createdViewsCount, 1)
    }
    
    func testPresenterGetsSimilarEvents() {
        //Given
        var isFetchedSimilarEvents = false
        selectedEventServiceMock.selectedEvent = Event(id: 2,
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
        XCTAssertEqual(viewMock.showMoreEventsButtonCount, 1)
        XCTAssertEqual(viewMock.similarEventsViewsCount, 2)
        XCTAssertEqual(viewMock.createdViewsCount, 1)
    }
    
    func testPresenterTryToGetSimilarEventWhenTheyAreAlreadyFetched() {
        //Given
        var isFetchedSimilarEvents = false
        selectedEventServiceMock.selectedEvent = Event(id: 3,
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
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertEqual(isFetchedSimilarEvents, true)
        XCTAssertEqual(viewMock.showMoreEventsButtonCount, 1)
        XCTAssertEqual(viewMock.similarEventsViewsCount, 3)
        XCTAssertEqual(viewMock.createdViewsCount, 1)
    }
    
    func testPresenterTryToFetchEventsWhereThereISNoSimilar() {
        //Given
        var isFetchedSimilarEvents = false
        selectedEventServiceMock.selectedEvent = Event(id: 5,
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
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertEqual(isFetchedSimilarEvents, true)
        XCTAssertEqual(viewMock.showMoreEventsButtonCount, 1)
        XCTAssertEqual(viewMock.similarEventsViewsCount, 0)
        XCTAssertEqual(viewMock.createdViewsCount, 1)
    }
}
