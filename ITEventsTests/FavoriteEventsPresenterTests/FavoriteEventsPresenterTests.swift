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
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        
        //When
        presenter.setup()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 1)
        XCTAssertEqual(viewMock.setEventsCount, 1)
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 1)
    }
    
    func testPresenterLoadMoreEvents() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { self.makeSearchBatchEventsAction(indexRange: $0, events: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.loadMoreEvents()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 2)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testPresenterAllEventsLoaded() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { self.makeSearchBatchEventsAction(indexRange: $0, events: allEvents) }
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
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testSearchPresenterActivate() {
        //Given
        eventStorageMock.searchEventsMocked = { _ in self.makeEmptyResult() }
        presenter.setup()

        //When
        presenter.activate()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.toggleLayoutCount, 1)
    }
    
    func testPresenterSelectEvent() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.selectEvent(with: allEvents[0].id)
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(selectedEventServiceMock.selectedEvent, allEvents[0])
    }
    
    private func createTestEvents() -> [Event] {
        var events: [Event] = []
        for index in Array(1..<10) {
            let event1 = Event(id: index * 2,
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
            let event2 = Event(id: index * 2 + 1,
                               title: "Test event2",
                               dateInterval: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24),
                                                          end: Date(timeIntervalSinceNow: 60 * 60 * 27)),
                               address: "Большой Сампсониевский проспект 28 к2 лит Д",
                               city: "Санкт-Петербург",
                               country: "Россия",
                               description: "Description for event CSS",
                               tags: [Tag(id: 1, name: "JavaScript"), Tag(id: 2, name: "CSS")],
                               image: UIImage(named: "js")!,
                               similarEventsCount: 2,
                               source: EventSource(id: 1, name: "Timepad"),
                               url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
            events.append(contentsOf: [event1, event2])
        }
        return events
    }
    
    private func makeSearchBatchEventsAction(indexRange: Range<Int>, events: [Event]) -> Cancelable<EventsResult> {
        let updatedIndexRange = events.count < indexRange.upperBound
            ? indexRange.lowerBound..<events.count
            : indexRange
        let batchEvents = Array(events[updatedIndexRange])
        return makeEventResult(with: batchEvents, totalEventsCount: events.count)
    }
    
    private func makeEventResult(with events: [Event], totalEventsCount: Int = 0) -> Cancelable<EventsResult> {
        let count = totalEventsCount == 0 ? events.count : totalEventsCount
        let eventsResult = EventsResult(events: events, totalEventsCount: count)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
    
    private func makeEmptyResult() -> Cancelable<EventsResult> {
        let eventsResult = EventsResult(events: [], totalEventsCount: 0)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
}
