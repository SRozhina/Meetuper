import XCTest

class FullEventViewUITests: XCTestCase {
    var app: XCUIApplication!
        
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
        let eventView = app.otherElements["EventView"]
        let eventImage = app.images["EventImage"]
        let eventTitle = app.staticTexts["EventTitle"]
        let eventDate = app.staticTexts["EventDate"]
        let eventCity = app.staticTexts["EventCity"]
        let eventAddress = app.staticTexts["EventAddress"]
        let eventDescription = app.staticTexts["EventDescription"]
        let eventTags = app.otherElements["EventTags"]
        let eventSourceButton = app.buttons["EventSourceButton"]
        //let showSimilarEventsButton = app.buttons["ShowSimilarEventsButton"]
        
        app.collectionViews.cells.element(boundBy: 0).tap()

        _ = eventView.waitForExistence(timeout: 3)
        XCTAssertTrue(eventView.exists)
        
        XCTAssertTrue(eventImage.exists)
        XCTAssertTrue(eventTitle.exists)
        XCTAssertTrue(eventDate.exists)
        
        XCTAssertTrue(eventCity.exists)
        XCTAssertTrue(eventAddress.exists)
        
        XCTAssertTrue(eventDescription.exists)
        
        XCTAssertTrue(eventTags.exists)
        XCTAssertTrue(eventSourceButton.exists)
    }
    
}
