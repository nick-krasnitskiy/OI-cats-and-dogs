//
//  WeatherModel.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.08.2021.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let feelsTemperature: Double
    let humidity: Int
    let pressure: Double
    let latitude: Double
    let longitude: Double
    let windSpeed: Double
    let windDeg: Int
    let cloudness: Int
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
}
