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
        
        //When
        presenter.setup()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 1)
        XCTAssertEqual(viewMock.setEventsCount, 1)
        XCTAssertEqual(viewMock.eventViweModels.count, 10)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 1)
    }
    
    func testPresenterLoadMoreEvents() {
        //Given
        
        //When
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.loadMoreEvents()
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(viewMock.loadingIndicatorShownCount, 2)
        XCTAssertEqual(viewMock.setEventsCount, 2)
        XCTAssertEqual(viewMock.eventViweModels.count, 18)
        XCTAssertEqual(viewMock.loadingIndicatorHidedCount, 2)
    }
    
    func testPresenterAllEventsLoaded() {
        //Given
        
        //When
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
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
        
        //When
        presenter.setup()
        XCTAssert(waitForPromises(timeout: 2))
        presenter.selectEvent(with: 1)
        
        //Then
        XCTAssert(waitForPromises(timeout: 2))
        XCTAssertEqual(selectedEventServiceMock.selectedEvent, event1)
    }
}
