//
//  CustomPin.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 11.08.2021.
//

import Foundation
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var tempFeelsLike: Double?
    var imageName: String?
    var cloudness: Int?
    var humidity: Int?
    var pressure: Double?
    var windSpeed: Double?
    var windDirection: Int?
    
    init(pinTitle: String, pinSubTitle: String, pinLocation: CLLocationCoordinate2D, pintempFL: Double, pinImageName: String, pinClouds: Int, pinHumid: Int, pinPress: Double, pinWindS: Double, pinwindD: Int) {
        
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = pinLocation
        self.tempFeelsLike = pintempFL
        self.imageName = pinImageName
        self.cloudness = pinClouds
        self.humidity = pinHumid
        self.pressure = pinPress
        self.windSpeed = pinWindS
        self.windDirection = pinwindD
    }
}
