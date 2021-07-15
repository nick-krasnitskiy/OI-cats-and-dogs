//
//  PersonManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 12.07.2021.
//

import Foundation

protocol PersonManagerDelegate: class {
    func getPersons(persons: [Person])
//    func startActivityIndicator()
//    func stopActivityIndicator()
    func didFailWithError(error: Error)
    func didFailWithResponce(response: HTTPURLResponse)
    func notResponce()
}

struct PersonManager {
    
    weak var delegate: PersonManagerDelegate?
    
    func fetchName(name: String) {
        let urlString = "https://swapi.dev/api/people/?search=\(name)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                     self.delegate?.didFailWithError(error: error)
                    return
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            if let safeData = data {
                                if let persons = self.parseJSON(data: safeData) {
                                    self.delegate?.getPersons(persons: persons.results)
                                }
                            }
                        case nil:
                            print("Nil")
                             self.delegate?.notResponce()
                        default:
                            print("Default")
                             self.delegate?.didFailWithResponce(response: httpResponse)
                        }
                    }
                }
            }
            task.resume()
        }
    }
        
    func parseJSON(data: Data) -> Persons? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Persons.self, from: data)
            let resuts = decodedData.results

            let persons = Persons(results: resuts)
            return persons
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
