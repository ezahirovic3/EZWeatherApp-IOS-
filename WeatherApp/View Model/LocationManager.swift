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
    @Published var city: String = ""
    @Published var country = ""
    @Published var showAlert = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            showAlert = false
            getLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            showAlert = false
        } else {
            showAlert = true
            getLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else { return }
        showAlert = false 
        longitude = latest.coordinate.longitude
        latitude = latest.coordinate.latitude
        getLocation()
    }
    
    func getLocation() {
        let latitude = latitude ?? 44.1748
        let longitude = longitude ?? 17.6634
        let location = CLLocation(latitude:latitude, longitude:longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.city = city
            self.country = locale(for: country.replacingOccurrences(of: "and", with: "&"))
        }
        weatherViewModel.getWeatherInternal(longitude: longitude, latitude: latitude)
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
