//
//  WeatherTests.swift
//  SmartMirrorTests
//
//  Created by Sander Geraedts on 19/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import XCTest

@testable import SmartMirror
class WeatherTests: XCTestCase {
    var weather1 : Weather?
    var weather2 : Weather?
    
    override func setUp() {
        weather1 = Weather(id: 0, city: "Eindhoven", main: "sunny", description: "Sunny", icon: "01.png", temp: 283.25, temp_min: 280.0, temp_max: 290.0, dateTime: 1547902410)
        weather2 = Weather(id: 1, city: "Atlantis", main: "Rainy", description: "Rain with showers", icon: "02.png", temp: 270.0, temp_min: 265.0, temp_max: 273.15, dateTime: Date())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetTempInCelsius() {
        if let testWeather1 = weather1 {
            XCTAssertEqual(testWeather1.getTempInCelsius(), 10.1, "Expected: 11.1 Got: \(testWeather1.getTempInCelsius())")
        } else {
            XCTFail()
        }
        
        if let testWeather2 = weather2 {
            XCTAssertEqual(testWeather2.getTempInCelsius(), -3.15, "Expected: -3.15 Got: \(testWeather2.getTempInCelsius())")
        } else {
            XCTFail()
        }
    }
    
    func testGetTempMaxInCelsius() {
        if let testWeather1 = weather1 {
            XCTAssertEqual(testWeather1.getTempMaxInCelsius(), 16.85, "Expected: 16.85 Got: \(testWeather1.getTempMaxInCelsius())")
        } else {
            XCTFail()
        }
        
        if let testWeather2 = weather2 {
            XCTAssertEqual(testWeather2.getTempMaxInCelsius(), 0.0, "Expected: 0.0 Got: \(testWeather2.getTempMaxInCelsius())")
        } else {
            XCTFail()
        }
    }
    
    func testGetTempMinInCelsius() {
        if let testWeather1 = weather1 {
            XCTAssertEqual(testWeather1.getTempMinInCelsius(), 6.85, "Expected: 6.85 Got: \(testWeather1.getTempMinInCelsius())")
        } else {
            XCTFail()
        }
        
        if let testWeather2 = weather2 {
            XCTAssertEqual(testWeather2.getTempMinInCelsius(), -8.15, "Expected: -8.15 Got: \(testWeather2.getTempMinInCelsius())")
        } else {
            XCTFail()
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
