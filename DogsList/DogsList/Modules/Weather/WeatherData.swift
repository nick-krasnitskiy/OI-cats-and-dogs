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
    let wind: Wind
    let clouds: Clouds
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let pressure: Double
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
