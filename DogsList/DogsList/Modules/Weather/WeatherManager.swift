//
//  WeatherManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.08.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b9b19061dee2ac39b6a172971ac2030e&units=metric"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        print(weather)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let name = decodedData.name
            let temp = decodedData.main.temp
            let feelsTemp = decodedData.main.feels_like
            let humid = decodedData.main.humidity
            let press = decodedData.main.pressure
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            let windSp = decodedData.wind.speed
            let windD = decodedData.wind.deg
            let clouds = decodedData.clouds.all
            
            let weather = WeatherModel(cityName: name, temperature: temp, feelsTemperature: feelsTemp, humidity: humid, pressure: press, latitude: lat, longitude: lon, windSpeed: windSp, windDeg: windD, cloudness: clouds)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
