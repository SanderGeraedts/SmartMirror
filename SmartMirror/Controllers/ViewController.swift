//
//  ViewController.swift
//  SmartMirror
//
//  Created by Sander Geraedts on 15/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let speechSynthesizer = AVSpeechSynthesizer()
    
    let weatherApiKey : String = "265460e4da92ab530fa98e9365998112"
    let weatherApiBaseURL : String = "https://api.openweathermap.org/data/2.5/weather"
    
    // UI Elements
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelMaxTemp: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude) latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            getCurrentWeather(lat: latitude, lon: longitude)
        }
    }
    
    func getCurrentWeather(lat: String, lon: String){
        let params : [String : String] = ["lat" : lat, "lon" : lon, "appid" : weatherApiKey]
        
        Alamofire.request(weatherApiBaseURL, method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)

                
                let weather = Weather(id: weatherJSON["id"].intValue, city: weatherJSON["name"].stringValue, main: weatherJSON["weather"][0]["main"].stringValue, description: weatherJSON["weather"][0]["description"].stringValue, icon: weatherJSON["weather"][0]["icon"].stringValue, temp: weatherJSON["main"]["temp"].floatValue, temp_min: weatherJSON["main"]["temp_min"].floatValue, temp_max: weatherJSON["main"]["temp_max"].floatValue, dateTime: weatherJSON["dt"].doubleValue)

                self.updateCurrentWeather(weather: weather)
            } else {
                self.labelDescription.text = "Connection Issues"
                print(response.result.error!)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        labelDescription.text = "Location unavailable"
    }
    
    func updateCurrentWeather(weather: Weather) {
        print(weather)
        
        if weather.description != "" {
            labelDescription.text = weather.description
            labelTemperature.text = "\(round(weather.getTempInCelsius()*10) / 10)°C"
            labelMinTemp.text = "Min temperature: \(round(weather.getTempMinInCelsius()*10) / 10)°C)"
            labelMaxTemp.text = "Max temperature: \(round(weather.getTempMaxInCelsius()*10) / 10)°C)"
            imgWeatherIcon.image = UIImage(named: String(weather.icon.prefix(2)))
            
            speak(text: prepareSpeechString(weather: weather))
        } else {
            labelDescription.text = "Service unavailable"
            speak(text: "Service unavailable, please try again later.")
        }
    }
    
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        
        speechUtterance.pitchMultiplier = 1.3
        speechUtterance.rate = 0.525
        
        speechSynthesizer.speak(speechUtterance)
    }
    
    func prepareSpeechString(weather: Weather) -> String {
        return "Today in \(weather.city), it's \(weather.description) with a high of \(Int(weather.getTempMaxInCelsius())) and a low of \(Int(weather.getTempMinInCelsius())). Currently it's \(round(weather.getTempInCelsius() * 10) / 10) degrees Celsius"
    }
}

