//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by MacBook Pro on 17. 11. 2022..
//

import Foundation
import UIKit
import MapKit
import SwiftUI

final class WeatherViewModel: ObservableObject {
    @Published var longitude : CLLocationDegrees
    @Published var latitude : CLLocationDegrees
    
    @Published var city = ""
    @Published var country = ""
    
    @Published var weather = WeatherResponse.empty()
    
    init(){
        //getLocation()
        latitude = 44.1748
        longitude = 17.6634
    }
    
    func getLocation() {
        //let latitude = latitude ?? 44.1748
        //let longitude = longitude ?? 17.6634
        let location = CLLocation(latitude:latitude, longitude:longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.city = city
            self.country = locale(for: country)
        }
        getWeatherInternal(longitude: longitude, latitude: latitude)
    }
    
    private func getWeatherInternal( longitude:CLLocationDegrees , latitude:CLLocationDegrees) {
        
        let urlString = WeatherApi.getCurrentWeatherURL(latitude: latitude, longitude: longitude)
        
        guard let url = URL(string: urlString) else {return}
        NetworkManager<WeatherResponse>.fetchWeather(for: url) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather = response
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var date: String {
        return Time.defaultDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.date)) )
    }
    
    var weatherIcon: String {
        return weather.current.weather.first?.icon ?? "sun"
    }
    
    var temperature: String {
        return getTempFor(weather.current.temperature)
    }
    
    var conditions: String {
        return weather.current.weather.first?.main ?? ""
    }
    
    var feelsLike: String {
        return "\(Int(weather.current.feelsLike))°"
    }
    
    var windSpeed: String {
        return String(format: "%0.1f", weather.current.windSpeed)
    }
    
    var humidity: String {
        return String(format: "%d%%", weather.current.humidity)
    }
    
    var pressure: String {
        return "\(weather.current.pressure) mbar"
    }
    
    var rainChances: String {
        return String(format: "%0.1f%%", weather.current.dewPoint)
    }
    
    func getTimeFor(_ temp: Int) -> String {
        return Time.timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getDayFor(_ temp: Int) -> String {
        return Time.dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getDayForV2(_ temp: Int) -> String {
        return Time.dayFormatterV2.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getDayNumber(_ temp: Int) -> String {
        return Time.dayNumberFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getTempFor(_ temp: Double) -> String {
        return String(format: "%1.0f°", temp)
    }
    
    func getWeatherIconFor(icon: String) -> Image {
        switch icon {
        case "01d":
            return Image("sun")
        case "01n":
            return Image("moon")
        case "02d":
            return Image("cloudSun")
        case "02n":
            return Image("cloudMoon")
        case "03d":
            return Image("cloud")
        case "03n":
            return Image("cloudMoon")
        case "04d":
            return Image("cloudMax")
        case "04n":
            return Image("cloudMoon")
        case "09d":
            return Image("rainy")
        case "09n":
            return Image("rainy")
        case "10d":
            return Image("rainySun")
        case "10n":
            return Image("rainyMoon")
        case "11d":
            return Image("thunderstormSun")
        case "11n":
            return Image("thunderstormMoon")
        case "13d":
            return Image("snowy")
        case "13n":
            return Image("snowy-2")
        case "50d":
            return Image("tornado")
        case "50n":
            return Image("tornado")
        default:
            return Image("sun")
        }
    }
}


// Nema koda za BiH
private func locale(for fullCountryName : String) -> String {
    let locales : String = ""
    for localeCode in NSLocale.isoCountryCodes {
        let identifier = NSLocale(localeIdentifier: localeCode)
        let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
        if fullCountryName.lowercased() == countryName?.lowercased() {
            return localeCode
        }
    }
    return locales
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
