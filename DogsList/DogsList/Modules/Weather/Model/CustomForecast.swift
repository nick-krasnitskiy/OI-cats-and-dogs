//
//  CustomForecast.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 11.08.2021.
//

import Foundation
import MapKit

class CustomForecast: NSObject {
    var day: String
    var lat: Double
    var lon: Double
    var temp: Double
    var imageName: String
    
    init(day: String, lat: Double, lon: Double, temp: Double, imageName: String) {
        self.day = day
        self.lat = lat
        self.lon = lon
        self.temp = temp
        self.imageName = imageName
    }
}
