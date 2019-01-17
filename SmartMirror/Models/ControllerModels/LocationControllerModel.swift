//
//  LocationControllerModel.swift
//  SmartMirror
//
//  Created by Sander Geraedts on 17/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import Foundation
import CoreLocation

class LocationControllerModel: CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    init() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}
