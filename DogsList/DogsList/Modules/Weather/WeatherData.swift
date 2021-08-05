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
    let coord: Coord
}

struct Main: Codable {
    let temp: Double
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
