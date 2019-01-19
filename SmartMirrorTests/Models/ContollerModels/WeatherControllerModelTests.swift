//
//  WeatherControllerModelTests.swift
//  SmartMirrorTests
//
//  Created by Sander Geraedts on 19/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import XCTest

@testable import SmartMirror
class WeatherControllerModelTests: XCTestCase {
    let weatherController : WeatherControllerModel = WeatherControllerModel()

    override func setUp() {
      
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCurrentWeather() {
        let lat = "51.45"
        let lon = "5.45"
        
        weatherController.getCurrentWeather(lat: lat, lon: lon, completion: {
            (weather) in
            XCTAssertNotNil(weather, "Weather should not be nil")
        })
    }
    
    func testGetCurrentWeather_FailedRequest() {
        let lat = "51000000.45"
        let lon = "5.45"
        
        weatherController.getCurrentWeather(lat: lat, lon: lon, completion: {
            (weather) in
            XCTAssertNil(weather, "Weather should be nil in case of a failed request")
        })
    }
    
    func testPrepareSpeechString() {
        let weather = Weather(id: 0, city: "Eindhoven", main: "sunny", description: "sunny", icon: "01.png", temp: 290.15, temp_min: 283.15, temp_max: 293.15, dateTime: nil)
        
        let expected = "Today in Eindhoven, it's sunny with a high of 20 and a low of 10. Currently it's 17.0 degrees Celsius"
        
        XCTAssertEqual(weatherController.prepareSpeechString(weather: weather), expected, "Message was not equal to expected")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let lat = "51.45"
            let lon = "5.45"
            
            weatherController.getCurrentWeather(lat: lat, lon: lon, completion: {
                (weather) in
                XCTAssertNotNil(weather, "Weather should not be nil")
            })
        }
    }

}
