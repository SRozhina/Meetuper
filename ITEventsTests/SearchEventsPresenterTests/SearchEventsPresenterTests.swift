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
        let events = createTestEvents()
        eventStorageMock = EventStorageMock(events: events)
        selectedEventServiceMock = SelectedEventServiceMock()
        searchParametersServiceMock = SearchParametersServiceMock()
        debouncerMock = DebouncerMock(actionQueue: DispatchQueue(label: "searchEventsDebouncedQueue"))
        
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
        
        //When
        presenter.setup()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 1)
        XCTAssertEqual(viewMock.setEventsCount, 1)
        XCTAssertEqual(viewMock.eventViweModels.count, 10)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 1)
    }
    
    func testSearchPresenterLoadMoreEvents() {
        //Given
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.loadMoreEvents()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 2)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, 18)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testSearchPresenterAllEventsLoaded() {
        //Given
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
        XCTAssertEqual(viewMock.eventViweModels.count, 18)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testSearchPresenterSearchByText() {
        //Given
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.searchEvents(by: "CSS")
        debouncerMock.actionQueue.sync { }
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, 9)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
    }
    
    func testSearchPresenterSearchByTheSameTextTwice() {
        //Given
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.searchEvents(by: "CSS")
        debouncerMock.actionQueue.sync { }
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.searchEvents(by: "CSS")
        
        //Then
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, 9)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
    }
    
    func testSearchPresenterSearchByTag() {
        //Given
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        searchParametersServiceMock.updateTags(selectedTags: [Tag(id: 2, name: "CSS")], otherTags: searchParametersServiceMock.otherTags)
        debouncerMock.actionQueue.sync { }
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 3)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, 9)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
        XCTAssertEqual(viewMock.eventsCleanedCount, 1)
    }
    
    func testSearchPresenterNoEventsFound() {
        //Given
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        
        //When
        presenter.searchEvents(by: "123")
        debouncerMock.actionQueue.sync { }
        
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
        let testTags = createTestTags()
        XCTAssertEqual(searchParametersServiceMock.otherTags, testTags)
        XCTAssertEqual(searchParametersServiceMock.selectedTags, [])
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
    
    func testSearchPresenterSelectEvent() {
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
        
        //When
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.selectEvent(with: 1)
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(selectedEventServiceMock.selectedEvent, event1)
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
}
