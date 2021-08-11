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
    func createForecast(_ weatherManager: WeatherManager, forecast: [ForecastModel])
    func didFailWithError(error: Error)
}

let apiKey = "b9b19061dee2ac39b6a172971ac2030e"
var forecast = [ForecastModel]()

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    let forecastURL = "https://api.openweathermap.org/data/2.5/onecall"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequestForWeather(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequestForWeather(with: urlString)
    }
    
    func fetchForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(forecastURL)?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,hourly,alerts&appid=\(apiKey)&units=metric"
        performRequestForForecast(with: urlString)
    }
    
    func performRequestForWeather(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSONForWeather(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONForWeather(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weather = WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp, feelsTemperature: decodedData.main.feels_like, humidity: decodedData.main.humidity, pressure: decodedData.main.pressure, latitude: decodedData.coord.lat, longitude: decodedData.coord.lon, windSpeed: decodedData.wind.speed, windDeg: decodedData.wind.deg, cloudness: decodedData.clouds.all)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func performRequestForForecast(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let forecast = self.parseJSONForForecast(safeData) {
                        self.delegate?.createForecast(self, forecast: forecast)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONForForecast(_ forecastData: Data) -> [ForecastModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            for day in 1...7 {
                forecast.append(ForecastModel(conditionId: decodedData.daily[day].weather[0].id, temperature: decodedData.daily[day].temp.day, timeInterval: decodedData.daily[day].dt))
            }
            return forecast
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
