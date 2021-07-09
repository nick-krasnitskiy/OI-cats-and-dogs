//
//  DogManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 06.07.2021.
//

import Foundation

protocol DogManagerDelegate: class {
    func addDogs(dogImages: [String])
    func startActivityIndicator()
    func stopActivityIndicator()
    func didFailWithError(error: Error)
    func didFailWithResponce(response: HTTPURLResponse)
    func notResponce()
}

struct DogManager {
    
    let imageURL = "https://dog.ceo/api/breed/hound/images/random/6"
    
    weak var delegate: DogManagerDelegate?
    
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
                                if let dog = self.parseJSON(data: safeData) {
                                    self.delegate?.addDogs(dogImages: dog.message)
                                    self.delegate?.stopActivityIndicator()
                                }
                            }
                        case nil:
                            self.delegate?.notResponce()
                            self.delegate?.stopActivityIndicator()
                        default:
                            self.delegate?.didFailWithResponce(response: httpResponse)
                            self.delegate?.stopActivityIndicator()
                        }
                    }
                }
            }
            task.resume()
        }
    }
        
    func parseJSON(data: Data) -> Dog? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Dog.self, from: data)
            
            let message = decodedData.message
            let status = decodedData.status
            
            let dog = Dog(message: message, status: status)
            return dog
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
