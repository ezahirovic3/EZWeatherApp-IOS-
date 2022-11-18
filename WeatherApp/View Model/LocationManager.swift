//
//  LocationManager.swift
//  WeatherApp
//
//  Created by MacBook Pro on 17. 11. 2022..
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    
    var locationManager = CLLocationManager()
    var weatherViewModel = WeatherViewModel()
    
    @Published var longitude : CLLocationDegrees?
    @Published var latitude : CLLocationDegrees?
    @Published var city = "Novi Travnik"
    @Published var country = "BA"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        weatherViewModel.getLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else { return }
        weatherViewModel.longitude = latest.coordinate.longitude
        weatherViewModel.latitude = latest.coordinate.latitude
        weatherViewModel.getLocation()
        self.city = weatherViewModel.city
        self.country = weatherViewModel.country
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        switch clError {
        case CLError.denied:
            print("Access denied")
        default:
            print("Catch all errors")
        }
    }
    
}
