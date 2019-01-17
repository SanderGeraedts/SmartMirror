//
//  Weather.swift
//  SmartMirror
//
//  Created by Sander Geraedts on 15/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import Foundation

class Weather {
    let id: Int
    let city: String
    let main: String
    let description: String
    let icon: String
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let dateTime: Date
    
    init(id: Int, city: String, main: String, description: String, icon: String, temp: Float, temp_min: Float, temp_max: Float, dateTime: Double?) {
        self.id = id
        self.city = city
        self.main = main
        self.description = description
        self.icon = icon
        self.temp = temp
        self.temp_min = temp_min
        self.temp_max = temp_max
        
        if let date = dateTime {
            self.dateTime = Date(timeIntervalSince1970: date)
        } else {
            self.dateTime = Date()
        }
    }
    
    init(id: Int, city: String, main: String, description: String, icon: String, temp: Float, temp_min: Float, temp_max: Float, dateTime: Date) {
        self.id = id
        self.city = city
        self.main = main
        self.description = description
        self.icon = icon
        self.temp = temp
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.dateTime = dateTime
    }
    
    func getTempInCelsius() -> Float {
        return self.temp - 273.15
    }
    
    func getTempMinInCelsius() -> Float {
        return self.temp_min - 273.15
    }
    
    func getTempMaxInCelsius() -> Float {
        return self.temp_max - 273.15
    }
}
