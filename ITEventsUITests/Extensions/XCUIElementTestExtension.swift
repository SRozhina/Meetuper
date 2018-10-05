//
//  XCUIElementTest.swift
//  ITEventsUITests
//
//  Created by Sofia on 05/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    func waitForDisappear(timeout: TimeInterval) -> Bool {
        let disappeared = NSPredicate(format: "exists == 0")
        let expectation = XCTNSPredicateExpectation(predicate: disappeared, object: self)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
