//
//  WeatherMapViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.08.2021.
//

import UIKit
import MapKit

class WeatherMapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var weatherManager = WeatherManager()
    private var temperature: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        addPinTapAction(mapView: mapView, target:self, action: #selector(addAnnotation))
    }
    
    func addPinTapAction(mapView: MKMapView, target: AnyObject, action: Selector, tapDuration: Double = 0.5) {
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: target, action: action)
        longPressRecognizer.minimumPressDuration = tapDuration
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer) {
        
        let annotation = MKPointAnnotation()
        let location = getTappedLocation(mapView: self.mapView, gestureRecognizer: gestureRecognizer)
        
        annotation.coordinate = location
        weatherManager.fetchWeather(latitude: location.latitude, longitude: location.longitude)
        DispatchQueue.main.async {
            if let temp = self.temperature {
                annotation.title = "Temperature = \(temp) °C"
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func getTappedLocation(mapView: MKMapView, gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
         
        let touchPoint = gestureRecognizer.location(in: mapView)
        return mapView.convert(touchPoint, toCoordinateFrom: mapView)
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherMapViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        temperature = weather.temperatureString
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
