//
//  AnimalManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import Foundation
import Alamofire

protocol AnimalManagerDelegate: AnyObject {
    func addDogBreed(breeds: [String])
    func addDogImage(breeds: [String])
    func startActivityIndicator()
    func stopActivityIndicator()
    func didFailWithError(error: Error)
    func didFailWithResponce(response: HTTPURLResponse)
    func notResponce()
}

enum Endpoint {
    case listAllDogBreeds
    case randomDogBreedImage(breed: String)
    
    var url: URL {
        switch self {
        case .listAllDogBreeds:
            return .makeForEndpoint("breeds/list/all")
        case .randomDogBreedImage(let breed):
            return .makeForEndpoint("/breed/\(breed)/images/random")
        }
    }
}

private var breeds = [String]()

struct AnimalManager {
    
    weak var delegate: AnimalManagerDelegate?
    
    func performRequest() {
        
        let endpointOne = Endpoint.listAllDogBreeds.url
        
        Session.default.request(endpointOne).responseDecodable(of: Animal.self) { response in
            
            switch response.result {
            case .success(let animals):
                for breed in animals.message {
                    breeds.append(breed.key)
                }
                breeds.shuffle()
                self.delegate?.addDogBreed(breeds: breeds)
                self.delegate?.stopActivityIndicator()
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://dog.ceo/api/\(endpoint)")!
    }
}
