//
//  SmartMirrorUITests.swift
//  SmartMirrorUITests
//
//  Created by Sander Geraedts on 15/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import XCTest

@testable import SmartMirror
class SmartMirrorUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGoToAppointment() {
        let validAddress = "10 Downing Street, London, UK"
        
        let app = XCUIApplication()
        let searchField = app.textFields["Address"]
        
        searchField.tap()
        
        searchField.typeText(validAddress)
        
        app.buttons["Go to appointment"].tap()
        
        let map = app.maps.firstMatch
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: map, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(map.exists)
    }
    
    func testGoToAppointment_FakeAddress() {
        let validAddress = "The Cupboard under the Stairs, 4 Privet Drive, Little Whinging, Surrey"
        
        let app = XCUIApplication()
        let searchField = app.textFields["Address"]
        
        searchField.tap()
        
        searchField.typeText(validAddress)
        
        app.buttons["Go to appointment"].tap()
        
        let map = app.maps.firstMatch
        
        expectation(for: NSPredicate(format: "exists == 0"), evaluatedWith: map, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertFalse(map.exists)
    }

}
