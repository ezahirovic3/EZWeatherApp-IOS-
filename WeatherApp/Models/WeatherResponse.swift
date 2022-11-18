//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by MacBook Pro on 17. 11. 2022..
//

import Foundation

struct Temperature: Codable {
    var min: Double
    var max: Double
}

struct WeatherDaily: Codable, Identifiable {
    var date: Int
    var temperature: Temperature
    var weather: [WeatherDetail]
    var id: UUID {
        UUID()
    }

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case weather = "weather"
    }

    init() {
        date = 0
        temperature = Temperature(min: 0.0, max: 0.0)
        weather = [WeatherDetail(main: "",
                                 description: "",
                                 icon: "")]
    }
}

struct WeatherResponse: Codable {
    var current: Weather
    var daily: [WeatherDaily]

    static func empty() -> WeatherResponse {
        WeatherResponse(
            current: Weather(),
            daily: [WeatherDaily](repeating: WeatherDaily(),
                                  count: 8)
        )
    }
}
