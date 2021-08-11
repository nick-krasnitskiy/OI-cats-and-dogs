//
//  ForecastData.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 11.08.2021.
//

import Foundation

struct ForecastData: Codable {
    let lat: Double
    let lon: Double
    let daily: [Daily]
}

struct Daily: Codable {
    let temp: Temp
    let dt: TimeInterval
    let weather: [Weather]
}

struct Temp: Codable {
    let day: Double
}
