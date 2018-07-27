import XCTest

class FullEventViewUITests: XCTestCase {
    private var app: XCUIApplication!
    
    private lazy var eventView = app.otherElements.matching(identifier: "EventView")
    private lazy var eventImage = app.images.matching(identifier: "EventImage")
    private lazy var eventTitle = app.staticTexts.matching(identifier: "EventTitle")
    private lazy var eventDate = app.staticTexts.matching(identifier: "EventDate")
    private lazy var eventCity = app.staticTexts.matching(identifier: "EventCity")
    private lazy var eventAddress = app.staticTexts.matching(identifier: "EventAddress")
    private lazy var eventDescription = app.staticTexts.matching(identifier: "EventDescription")
    private lazy var eventTags = app.otherElements.matching(identifier: "EventTags")
    private lazy var eventSourceButton = app.buttons.matching(identifier: "EventSourceButton")
    private lazy var showSimilarEventsButton = app.otherElements["ShowSimilarEventsButton"]
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFullEventViewContent() {
        app.collectionViews.cells.element(boundBy: 0).tap()

        if !eventView.element.waitForExistence(timeout: 3) { XCTFail("No Event View Found") }
        XCTAssertTrue(eventView.element.exists)
        
        XCTAssertTrue(eventImage.element.exists)
        XCTAssertTrue(eventTitle.element.exists)
        XCTAssertTrue(eventDate.element.exists)
        
        XCTAssertTrue(eventCity.element.exists)
        XCTAssertTrue(eventAddress.element.exists)
        
        XCTAssertTrue(eventDescription.element.exists)
        
        XCTAssertTrue(eventTags.element.exists)
        XCTAssertTrue(eventSourceButton.element.exists)
    }
    
    func testFullEventViewShowSimilarEvents() {
        var isEventWithSimilarFound = false
        
        _ = app.collectionViews.cells.element.waitForExistence(timeout: 3)
        
        for index in 0..<app.collectionViews.cells.count - 1 {
            app.collectionViews.cells.element(boundBy: index).tap()
            _ = eventView.element.waitForExistence(timeout: 3)
            if showSimilarEventsButton.exists {
                isEventWithSimilarFound = true
                break
            }
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        if !isEventWithSimilarFound { XCTFail("There is no events with similar") }
        
        showSimilarEventsButton.tap()
        if !app.buttons["Show less descriptions"].waitForExistence(timeout: 3) { XCTFail("No Show less descriptions button found") }
        XCTAssertGreaterThan(eventView.count, 1)
        XCTAssertGreaterThan(eventImage.count, 1)
        XCTAssertGreaterThan(eventTitle.count, 1)
        XCTAssertGreaterThan(eventDate.count, 1)
        XCTAssertGreaterThan(eventCity.count, 1)
        XCTAssertGreaterThan(eventAddress.count, 1)
        XCTAssertGreaterThan(eventDescription.count, 1)
        XCTAssertGreaterThan(eventTags.count, 1)
        XCTAssertGreaterThan(eventSourceButton.count, 1)
    }
    
    func testFullEventViewHideSimilarEvents() {
        var isEventWithSimilarFound = false
        
        _ = app.collectionViews.cells.element.waitForExistence(timeout: 3)
        
        for index in 0..<app.collectionViews.cells.count - 1 {
            app.collectionViews.cells.element(boundBy: index).tap()
            _ = eventView.element.waitForExistence(timeout: 3)
            if showSimilarEventsButton.exists {
                isEventWithSimilarFound = true
                break
            }
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        if !isEventWithSimilarFound { XCTFail("There is no events with similar") }
        
        showSimilarEventsButton.tap()
        if !app.buttons["Show less descriptions"].waitForExistence(timeout: 3) { XCTFail("No Show less descriptions button found") }
        app.buttons["Show less descriptions"].tap()
        XCTAssertEqual(eventView.count, 1)
        XCTAssertEqual(eventImage.count, 1)
        XCTAssertEqual(eventTitle.count, 1)
        XCTAssertEqual(eventDate.count, 1)
        XCTAssertEqual(eventCity.count, 1)
        XCTAssertEqual(eventAddress.count, 1)
        XCTAssertEqual(eventDescription.count, 1)
        XCTAssertEqual(eventTags.count, 1)
        XCTAssertEqual(eventSourceButton.count, 1)
    }
    
    func testFullEventViewOpenEventSource() {
        app.collectionViews.cells.element(boundBy: 0).tap()
        eventSourceButton.element.tap()
        XCTAssertTrue(app.otherElements["URL"].exists)
    }
}
