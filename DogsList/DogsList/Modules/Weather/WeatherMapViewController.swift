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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPinTapAction(mapView: mapView, target:self, action: #selector(addAnnotation))
    }
    
    func addPinTapAction(mapView: MKMapView, target: AnyObject, action: Selector, tapDuration: Double = 0.1) {
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: target, action: action)
        longPressRecognizer.minimumPressDuration = tapDuration
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer) {
        
        let location = getTappedLocation(mapView: self.mapView, gestureRecognizer: gestureRecognizer)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Temperature = 20 C"
        //annotation.subtitle = "City name"
        
        mapView.addAnnotation(annotation)
    }
    
    func getTappedLocation(mapView: MKMapView, gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
         
        let touchPoint = gestureRecognizer.location(in: mapView)
        return mapView.convert(touchPoint, toCoordinateFrom: mapView)
    }
}
