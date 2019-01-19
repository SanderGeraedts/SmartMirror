//
//  MapViewController.swift
//  SmartMirror
//
//  Created by Sander Geraedts on 19/01/2019.
//  Copyright © 2019 Code Panda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//TODO: Clean up
class MapViewController: UIViewController, CLLocationManagerDelegate {
    var destination : CLLocation?
    let locationManager = CLLocationManager()
    var directionsArray: [MKDirections] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true

        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        } else {
            print("Please turn on location services or GPS")
        }
    }
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate{ [unowned self] (response, error) in
            guard let response = response else { return }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = destination?.coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destinationLocation         = MKPlacemark(coordinate: destinationCoordinate!)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destinationLocation)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = false
        
        return request
    }
    
    // MARK: - Location Manager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
        
        let sourcePin = CustomPin(pinTitle: "Your location", pinSubTitle: "", location: locations[0].coordinate)
        let destinationPin = CustomPin(pinTitle: "Your destination", pinSubTitle: "", location: (destination?.coordinate)!)
        
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        getDirections()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
}

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
