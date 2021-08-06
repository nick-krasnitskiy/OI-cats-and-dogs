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
    
    private var name: String?
    private var temperature: String?
    private var latitude: Double?
    private var longitude: Double?

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
    
    func addSearchAnnotaion() {

        let annotation = MKPointAnnotation()
        DispatchQueue.main.async {
            if let cityName = self.name, let temp = self.temperature, let latitude = self.latitude, let longitude = self.longitude {
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = cityName
                annotation.subtitle = "Temperature = \(temp) °C"
                self.mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                self.mapView.setRegion(region, animated: true)
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
        name = weather.cityName
        temperature = weather.temperatureString
        latitude = weather.latitude
        longitude = weather.longitude
        
        addSearchAnnotaion()
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let detailViewController = storyboard.instantiateViewController(identifier: "WeatherDetail") as? WeatherDetailViewController else { return }
           // detailViewController.cityName = "Moscow"
                    
                    show(detailViewController, sender: nil)
                
            }
        }
    }

