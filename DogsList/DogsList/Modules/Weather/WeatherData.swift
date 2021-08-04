//
//  WeatherData.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.08.2021.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
}

struct Main: Codable {
    let temp: Double
}
