//
//  WeatherMapViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.08.2021.
//

import UIKit
import MapKit

private class CustomPin: NSObject, MKAnnotation {
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

class WeatherMapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        weatherManager.delegate = self
        searchBar.delegate = self
        addPinTapAction(mapView: mapView, target:self, action: #selector(addTapAnnotation))
        hideKeyboardWhenTappedAround()
    }
    
    func addPinTapAction(mapView: MKMapView, target: AnyObject, action: Selector, tapDuration: Double = 0.1) {
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: target, action: action)
        longPressRecognizer.minimumPressDuration = tapDuration
        mapView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func addTapAnnotation(gestureRecognizer:UIGestureRecognizer) {
        
        let location = getTappedLocation(mapView: self.mapView, gestureRecognizer: gestureRecognizer)
        weatherManager.fetchWeather(latitude: location.latitude, longitude: location.longitude)
    }
    
    func addSearchAnnotaion(weather: WeatherModel) {
        print(weather.temperature)
        DispatchQueue.main.async { [self] in
            let pin = CustomPin(pinTitle: weather.cityName, pinSubTitle: "Temperature = \(String(format: "%.f", weather.temperature)) °C", pinLocation: CLLocationCoordinate2D(latitude: weather.latitude, longitude: weather.longitude), pintempFL: weather.feelsTemperature, pinImageName: weather.conditionName, pinClouds: weather.cloudness, pinHumid: weather.humidity, pinPress: weather.pressure, pinWindS: weather.windSpeed, pinwindD: weather.windDeg)
            
            let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(pin)
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
        addSearchAnnotaion(weather: weather)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - UISearchBarDelegate

extension WeatherMapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            weatherManager.fetchWeather(cityName: text)
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - DismissKeyboard

extension WeatherMapViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(WeatherMapViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - MKMapViewDelegate

extension WeatherMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.image = UIImage(named: "location")
        annotationView.canShowCallout = true
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = btn
        
        DispatchQueue.main.async { [self] in
            mapView.selectAnnotation(annotation, animated: true)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let weatherDetailVC = storyBoard.instantiateViewController(withIdentifier: "WeatherDetail") as? WeatherDetailViewController else { return }
            guard let weather = annotationView.annotation as? CustomPin else { return }
            
            if let name = weather.title, let temp = weather.subtitle, let tempFL = weather.tempFeelsLike, let image = weather.imageName, let clouds = weather.cloudness, let humid = weather.humidity, let press = weather.pressure, let windS = weather.windSpeed, let windD = weather.windDirection {
                
                weatherDetailVC.name = name
                weatherDetailVC.temp = temp
                weatherDetailVC.tempFL = tempFL
                weatherDetailVC.image = image
                weatherDetailVC.clouds = clouds
                weatherDetailVC.humid = humid
                weatherDetailVC.press = press
                weatherDetailVC.windS = windS
                weatherDetailVC.windD = windD
            }
            self.navigationController?.pushViewController(weatherDetailVC, animated: true)
        }
    }
}
