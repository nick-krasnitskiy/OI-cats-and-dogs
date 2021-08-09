//
//  WeatherMapViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.08.2021.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(pinTitle: String, pinSubTitle: String, pinLocation: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = pinLocation
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
    
    func addSearchAnnotaion(name: String, temp: String, latitude: Double, longitude: Double) {
        
        DispatchQueue.main.async { [self] in
            let pin = CustomPin(pinTitle: name, pinSubTitle: "Temperature = \(temp) °C", pinLocation:  CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
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
        addSearchAnnotaion(name: weather.cityName, temp: weather.temperatureString, latitude: weather.latitude, longitude: weather.longitude)
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailViewController = storyboard.instantiateViewController(identifier: "WeatherDetail") as? WeatherDetailViewController else { return }
            // detailViewController.cityName = "Moscow"
            show(detailViewController, sender: nil)
        }
    }
}
