import XCTest
@testable import Promises
@testable import ITEvents

class FavoriteEventsPresenterTests: XCTestCase {
    private var presenter: IFavoritePresenter!
    private var viewMock: FavoriteViewMock!
    private var selectedEventServiceMock: SelectedEventServiceMock!
    private var eventStorageMock: EventStorageMock!
    
    override func setUp() {
        super.setUp()
        
        viewMock = FavoriteViewMock()
        selectedEventServiceMock = SelectedEventServiceMock()
        eventStorageMock = EventStorageMock()
        
        presenter = FavoritePresenter(view: viewMock,
                                      eventStorage: eventStorageMock,
                                      selectedEventService: selectedEventServiceMock,
                                      userSettingsService: UserSettingsServiceMock(),
                                      dateFormatterService: DateFormatterServiceMock())
    }
    
    override func tearDown() {
        presenter = nil
        viewMock = nil
        selectedEventServiceMock = nil
        eventStorageMock = nil
        super.tearDown()
    }
    
    func testPresenterSetup() {
        //Given
        eventStorageMock.events = createTestEvents()
        eventStorageMock.searchAction = makeSearchAction
        
        //When
        presenter.setup()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 1)
        XCTAssertEqual(viewMock.setEventsCount, 1)
        XCTAssertEqual(viewMock.eventViweModels.count, eventStorageMock.events.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 1)
    }
    
    func testPresenterLoadMoreEvents() {
        //Given
        eventStorageMock.events = createTestEvents()
        eventStorageMock.searchAction = makeSearchButchEventsAction
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.loadMoreEvents()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 2)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, eventStorageMock.events.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testPresenterAllEventsLoaded() {
        //Given
        eventStorageMock.events = createTestEvents()
        eventStorageMock.searchAction = makeSearchButchEventsAction
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.loadMoreEvents()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.loadMoreEvents()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 2)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, eventStorageMock.events.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testSearchPresenterActivate() {
        //Given
        presenter.setup()

        //When
        presenter.activate()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.toggleLayoutCount, 1)
    }
    
    func testPresenterSelectEvent() {
        //Given
        let event1 = Event(id: 1,
                           title: "Test event1",
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
        eventStorageMock.events = Array(repeating: event1, count: 5)
        eventStorageMock.searchAction = makeSearchAction
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.selectEvent(with: 1)
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(selectedEventServiceMock.selectedEvent, event1)
    }
    
    private func createTestEvents() -> [Event] {
        var events: [Event] = []
        let event1 = Event(id: 1,
                           title: "Test event1",
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
        let event2 = Event(id: 2,
                           title: "Test event2",
                           dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                      end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                           address: "Большой Сампсониевский проспект 28 к2 лит Д",
                           city: "Санкт-Петербург",
                           country: "Россия",
                           description: "Description for event",
                           tags: [Tag(id: 1, name: "JavaScript"), Tag(id: 1, name: "CSS")],
                           image: UIImage(named: "js")!,
                           similarEventsCount: 2,
                           source: EventSource(id: 1, name: "Timepad"),
                           url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        for _ in Array(1..<10) {
            events.append(contentsOf: [event1, event2])
        }
        return events
    }
    
    private func makeSearchAction(indexRange: Range<Int>? = nil,
                                  searchText: String? = nil,
                                  searchTags: [Tag]? = nil) -> Cancelable<EventsResult> {
        return makeEventResult(with: eventStorageMock.events)
    }
    
    private func makeSearchButchEventsAction(indexRange: Range<Int>,
                                             searchText: String? = nil,
                                             searchTags: [Tag]? = nil) -> Cancelable<EventsResult> {
        let events = eventStorageMock.events
        let updatedIndexRange = events.count < indexRange.upperBound
            ? indexRange.lowerBound..<events.count
            : indexRange
        let butchEvents = Array(events[updatedIndexRange])
        return makeEventResult(with: butchEvents)
    }
    
    private func makeEventResult(with events: [Event]) -> Cancelable<EventsResult> {
        let eventsResult = EventsResult(events: events, totalEventsCount: eventStorageMock.events.count)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
}
