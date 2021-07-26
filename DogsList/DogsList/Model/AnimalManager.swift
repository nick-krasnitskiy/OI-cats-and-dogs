//
//  AnimalManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import Foundation
import Alamofire

protocol AnimalManagerDelegate: AnyObject {
    func addAnimal(animals: [Animal])
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
            return .makeForEndpoint("breed/\(breed)/images/random")
        }
    }
}
var animalObjects = [Animal]()

struct AnimalManager {
    
    weak var delegate: AnimalManagerDelegate?
    
    func performRequest() {
        let group = DispatchGroup()
        
        let endpointOne = Endpoint.listAllDogBreeds.url
        AF.request(endpointOne).responseDecodable(of: DogBreed.self) { response in
            
            switch response.result {
            case .success(let breeds):
                let breeds = breeds.message.keys.map{String($0)}
                
                for breed in breeds {
                    group.enter()
                    let endpointTwo = Endpoint.randomDogBreedImage(breed: breed).url
                    AF.request(endpointTwo).responseDecodable(of: DogImage.self) { response in
                        
                        switch response.result {
                        case .success(let images):
                            animalGenerate(animals: (breed, images.message))
                            group.leave()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.delegate?.addAnimal(animals: animalObjects)
                    self.delegate?.stopActivityIndicator()
                }
                
            // print(breeds) // here add local store to Core Data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func animalGenerate(animals: (String, String)) {
        let breed = animals.0
        let image = animals.1
        animalObjects.append(Animal(breed: breed, image: image))
    }
    
}

private extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://dog.ceo/api/\(endpoint)")!
    }
}

