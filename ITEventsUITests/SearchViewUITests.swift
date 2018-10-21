//
//  SearchViewUITests.swift
//  ITEventsUITests
//
//  Created by Sofia on 21/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import XCTest

class SearchViewUITests: XCTestCase {
    //TODO all copied from favorite view
    private var app: XCUIApplication!
    private lazy var activityIndicator = app.collectionViews.activityIndicators["ActivityIndicator"]
    
    private lazy var eventImage = app.images.matching(identifier: "EventImage")
    private lazy var eventTitle = app.staticTexts.matching(identifier: "EventTitle")
    private lazy var eventDate = app.staticTexts.matching(identifier: "EventDate")
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShowFavoriteEvents() {
        if !activityIndicator.waitForExistence(timeout: 5) { XCTFail("Activity indicator is not shown") }
        if !activityIndicator.waitForDisappear(timeout: 5) { XCTFail("Activity indicator is not hiden") }
        if app.collectionViews.cells.count == 0 { XCTFail("No events was loaded") }
    }
    
    
    func testShowEventCellContent() {
        _ = app.collectionViews.cells.element.waitForExistence(timeout: 3)
        XCTAssert(eventImage.element.exists)
        XCTAssert(eventTitle.element.exists)
        XCTAssert(eventDate.element.exists)
    }
    
    func testLoadMoreEvents() {
        _ = app.collectionViews.cells.element.waitForExistence(timeout: 3)
        app.swipeUp()
        if !activityIndicator.waitForExistence(timeout: 5) { XCTFail("Activity indicator is not shown") }
        if !activityIndicator.waitForDisappear(timeout: 5) { XCTFail("Activity indicator is not hiden") }
        #warning ("for more stable tests I have to increase request time in InMemory storage. Is it OK? If yes I could add test for loadAllData")
    }
}
