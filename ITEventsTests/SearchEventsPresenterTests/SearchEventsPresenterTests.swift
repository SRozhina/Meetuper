import XCTest
@testable import Promises
@testable import ITEvents

class SearchEventsPresenterTests: XCTestCase {
    private var presenter: ISearchPresenter!

    private var viewMock: SearchViewMock!
    private var eventStorageMock: EventStorageMock!
    private var selectedEventServiceMock: SelectedEventServiceMock!
    private var searchParametersServiceMock: SearchParametersServiceMock!
    private var debouncerMock: DebouncerMock!
    
    override func setUp() {
        super.setUp()
        viewMock = SearchViewMock()
        eventStorageMock = EventStorageMock()
        selectedEventServiceMock = SelectedEventServiceMock()
        searchParametersServiceMock = SearchParametersServiceMock()
        debouncerMock = DebouncerMock()
        
        let tags = createTestTags()
        
        presenter = SearchPresenter(view: viewMock,
                                    eventsStorage: eventStorageMock,
                                    selectedEventService: selectedEventServiceMock,
                                    userSettingsService: UserSettingsServiceMock(),
                                    dateFormatterService: DateFormatterServiceMock(),
                                    tagsStorage: EventTagsStorageMock(tags: tags),
                                    searchParametersService: searchParametersServiceMock,
                                    debouncer: debouncerMock)
    }
    
    override func tearDown() {
        presenter = nil
        viewMock = nil
        eventStorageMock = nil
        selectedEventServiceMock = nil
        searchParametersServiceMock = nil
        super.tearDown()
    }
    
    func testSearchPresenterSetup() {
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
    
    func testSearchPresenterLoadMoreEvents() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { self.makeSearchButchEventsAction(indexRange: $0, events: allEvents) }
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
    
    func testSearchPresenterAllEventsLoaded() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { self.makeSearchButchEventsAction(indexRange: $0, events: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.loadMoreEvents()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.loadMoreEvents()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 2)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testSearchPresenterSearchByText() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.searchEvents(by: "CSS")
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
    }
    
    func testSearchPresenterSearchByTheSameTextTwice() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.searchEvents(by: "CSS")
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.searchEvents(by: "CSS")
        
        //Then
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
    }
    
    func testSearchPresenterSearchByTag() {
        //Given
        let allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        searchParametersServiceMock.updateTags(selectedTags: [Tag(id: 2, name: "CSS")], otherTags: searchParametersServiceMock.otherTags)
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, allEvents.count)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
    }
    
    func testSearchPresenterNoEventsFound() {
        //Given
        var allEvents = createTestEvents()
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        allEvents = []
        
        //When
        presenter.searchEvents(by: "123")
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, 0)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
        XCTAssertEqual(viewMock.backgroundViewShownCount, 1)
    }
    
    func testSearchPresenterGetSearchParameters() {
        //Given
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.prepareSearchParameters(completion: { })
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        let expectedTags = createTestTags().sorted { $0.name < $1.name }
        XCTAssertEqual(searchParametersServiceMock.otherTags, expectedTags)
        XCTAssertEqual(searchParametersServiceMock.selectedTags, [])
    }
    
    func testSearchPresenterActivate() {
        //Given
        presenter.setup()
        
        //When
        presenter.activate()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.toggleLayoutCallsCount, 1)
    }
    
    func testSearchPresenterSelectEvent() {
        //Given
        let event = Event(id: 1,
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
        let allEvents = Array(repeating: event, count: 5)
        eventStorageMock.searchEventsMocked = { _ in self.makeEventResult(with: allEvents) }
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))

        //When
        presenter.selectEvent(with: 1)
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(selectedEventServiceMock.selectedEvent, event)
    }
    
    private func createTestTags() -> [Tag] {
        return [
            Tag(id: 1, name: "JavaScript"),
            Tag(id: 2, name: "iOS"),
            Tag(id: 3, name: "Android"),
            Tag(id: 4, name: "Python"),
            Tag(id: 5, name: "php"),
            Tag(id: 6, name: "Dart"),
            Tag(id: 7, name: "CSS"),
            Tag(id: 8, name: "Go"),
            Tag(id: 9, name: "Frontend")
        ]
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
                           description: "Description for event CSS",
                           tags: [Tag(id: 1, name: "JavaScript"), Tag(id: 2, name: "CSS")],
                           image: UIImage(named: "js")!,
                           similarEventsCount: 2,
                           source: EventSource(id: 1, name: "Timepad"),
                           url: URL(string: "https://pitercss.timepad.ru/event/457262/"))
        for _ in Array(1..<10) {
            events.append(contentsOf: [event1, event2])
        }
        return events
    }
    
    private func makeSearchButchEventsAction(indexRange: Range<Int>, events: [Event]) -> Cancelable<EventsResult> {
        let updatedIndexRange = events.count < indexRange.upperBound
            ? indexRange.lowerBound..<events.count
            : indexRange
        let butchEvents = Array(events[updatedIndexRange])
        return makeEventResult(with: butchEvents, totalEventsCount: events.count)
    }
    
    private func makeEventResult(with events: [Event], totalEventsCount: Int = 0) -> Cancelable<EventsResult> {
        let count = totalEventsCount == 0 ? events.count : totalEventsCount
        let eventsResult = EventsResult(events: events, totalEventsCount: count)
        let promise = Promise(eventsResult)
        return Cancelable<EventsResult>(promise: promise)
    }
}
