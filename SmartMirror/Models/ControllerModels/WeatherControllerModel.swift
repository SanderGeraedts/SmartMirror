//
//  WeatherControllerModel.swift
//  SmartMirror
//
//  Created by Sander Geraedts on 16/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherControllerModel {
    let weatherApiKey : String = "265460e4da92ab530fa98e9365998112"
    let weatherApiBaseURL : String = "https://api.openweathermap.org/data/2.5/"
    
    func getCurrentWeather(lat: String, lon: String, completion: @escaping (Weather?) -> Void) {
        let params : [String : String] = ["lat" : lat, "lon" : lon, "appid" : weatherApiKey]
        
        Alamofire.request(weatherApiBaseURL + "weather", method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                
                // check if JSON object is actually filled
                if(weatherJSON["weather"].array == nil) {
                    completion(nil)
                    return
                }
                
                
                let weather = Weather(id: weatherJSON["id"].intValue, city: weatherJSON["name"].stringValue, main: weatherJSON["weather"][0]["main"].stringValue, description: weatherJSON["weather"][0]["description"].stringValue, icon: weatherJSON["weather"][0]["icon"].stringValue, temp: weatherJSON["main"]["temp"].floatValue, temp_min: weatherJSON["main"]["temp_min"].floatValue, temp_max: weatherJSON["main"]["temp_max"].floatValue, dateTime: weatherJSON["dt"].doubleValue)
                
                completion(weather)
            } else {
                completion(nil)
                print(response.result.error!)
            }
        }
    }
    
    func getWeatherForecast(lat: String, lon: String, completion: @escaping ([Weather]?) -> Void) {
        let params : [String : String] = ["lat" : lat, "lon" : lon, "appid" : weatherApiKey]
        var weatherForecast : [Weather] = []
        
        Alamofire.request(weatherApiBaseURL + "forecast", method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess {
                let data : JSON = JSON(response.result.value!)
                
                for (key, weatherJSON) in data["list"] {
                
                    let weather = Weather(id: weatherJSON["id"].intValue, city: weatherJSON["name"].stringValue, main: weatherJSON["weather"][0]["main"].stringValue, description: weatherJSON["weather"][0]["description"].stringValue, icon: weatherJSON["weather"][0]["icon"].stringValue, temp: weatherJSON["main"]["temp"].floatValue, temp_min: weatherJSON["main"]["temp_min"].floatValue, temp_max: weatherJSON["main"]["temp_max"].floatValue, dateTime: weatherJSON["dt"].doubleValue)
                    
                    // Get every 8th entry. API returns values in sections of 3 hours. Every 8th entry means the next day
                    if(Int(key)! % 8 == 0) {
                        weatherForecast.append(weather)
                    }
                }
                
                completion(weatherForecast)
            } else {
                completion(nil)
                print(response.result.error!)
            }
        }
    }
    
    func prepareSpeechString(weather: Weather) -> String {
        return "Today in \(weather.city), it's \(weather.description) with a high of \(Int(weather.getTempMaxInCelsius())) and a low of \(Int(weather.getTempMinInCelsius())). Currently it's \(round(weather.getTempInCelsius() * 10) / 10) degrees Celsius"
    }
}
