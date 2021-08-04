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
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
}
