//
//  ForecastModel.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 11.08.2021.
//

import Foundation

struct ForecastModel {
    let conditionId: Int
    let temperature: Double
    let timeInterval: TimeInterval
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
