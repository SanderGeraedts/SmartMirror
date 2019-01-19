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

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Properties & Managers
    let locationManager = CLLocationManager()
    
    let speechController = SpeechControllerModel()
    let weatherController = WeatherControllerModel()
    
    var weatherForecast : [Weather] = []
    var location : CLLocation?
    var timer : Timer = Timer()

    // MARK: - UI Elements
    // Current Weather
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelMinTemp: UILabel!
    @IBOutlet weak var labelMaxTemp: UILabel!
    
    // Forecast
    @IBOutlet weak var collectionForecastView: UICollectionView!
    
    // Maps
    @IBOutlet weak var txtAddress: UITextField!
    
    // Time
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        
        tick()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Location Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            getCurrentWeather(lat: latitude, lon: longitude)
            getWeatherForecast(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        labelDescription.text = "Location unavailable"
    }
    
    // I did not hit her, it's not true!
    // It's bullshit! I did not hit her!
    // I did naaaaht
    // oh hi, MARK: - API Controller calls
    func getCurrentWeather(lat: String, lon: String){
        weatherController.getCurrentWeather(lat: lat, lon: lon, completion: {
            (result) in
            if let weather = result {
                self.updateCurrentWeather(weather: weather)
            } else {
                self.labelDescription.text = "Connection Issues"
            }
        })
    }
    
    func getWeatherForecast(lat: String, lon: String) {
        weatherController.getWeatherForecast(lat: lat, lon: lon, completion: {
            (result) in
            if let forecast = result {
                self.weatherForecast = forecast
                self.collectionForecastView.reloadData()
            } else {
                self.labelDescription.text = "Connection Issues"
            }
        })
    }
    
    // MARK: - UI Functions
    func updateCurrentWeather(weather: Weather) {
        if weather.description != "" {
            labelDescription.text = weather.description
            labelTemperature.text = "\(round(weather.getTempInCelsius()*10) / 10)°C"
            labelMinTemp.text = "Min temperature: \(round(weather.getTempMinInCelsius()*10) / 10)°C"
            labelMaxTemp.text = "Max temperature: \(round(weather.getTempMaxInCelsius()*10) / 10)°C"
            imgWeatherIcon.image = UIImage(named: String(weather.icon.prefix(2)))
            
            speechController.speak(text: weatherController.prepareSpeechString(weather: weather))
        } else {
            labelDescription.text = "Service unavailable"
            speechController.speak(text: "Service unavailable, please try again later.")
        }
    }
    
    // Number of items in CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherForecast.count
    }
    
    // Populate the collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastViewCell
        
        cell.labelDay.text = weatherForecast[indexPath.item].dateTime.dayOfWeek()
        cell.imgForecastIcon.image = UIImage(named: String(weatherForecast[indexPath.item].icon.prefix(2)))
        cell.labelMaxTemp.text = "Max: \(round(weatherForecast[indexPath.item].getTempMaxInCelsius()*10)/10)°C"
        cell.labelMinTemp.text = "Min: \(round(weatherForecast[indexPath.item].getTempMinInCelsius()*10)/10)°C"
        return cell
    }
    
    // MARK: - Map Event Triggers
    @IBAction func appointmentButtonPressed(_ sender: Any) {
        if let address = txtAddress.text {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard let placemarks = placemarks, let location = placemarks.first?.location else {
                    self.speechController.speak(text: "Sorry, we couldn't find the address, please try again.")
                    return
                }
                self.location = location
                
                self.performSegue(withIdentifier: "goToMapScreen", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMapScreen" {
            let destinationVC = segue.destination as! MapViewController
            
            destinationVC.destination = location
        }
    }
    
    // MARK: - Time Function
    @objc func tick() {
        let date = Date()
        
        labelTime.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        labelDate.text = DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .none)
    }
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
