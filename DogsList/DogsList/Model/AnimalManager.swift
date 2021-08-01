//
//  AnimalManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import Foundation
import Alamofire

protocol AnimalDelegate: AnyObject {
    func addAnimal(animals: [Animal])
    func addAnimalImage(animalImages: [AnimalImages])
    func startActivityIndicator()
    func stopActivityIndicator()
    func didFailWithError(error: Error)
    func didFailWithResponce(response: HTTPURLResponse)
    func notResponce()
}

protocol AnimalImagesDelegate: AnyObject {
    func addAnimalImage(animals: [AnimalImages])
}

private let limit = 100

enum Endpoint {
    case listAllDogBreeds
    case listAllCatBreeds
    case randomDogBreedImage(breed: String)
    case breedDogImages(breed: String)
    case breedCatImages(breedId: String)
    
    var url: URL {
        switch self {
        case .listAllDogBreeds:
            return .makeForDogEndpoint("breeds/list/all")
        case .listAllCatBreeds:
            return .makeForCatEndpoint("breeds")
        case .randomDogBreedImage(let breed):
            return .makeForDogEndpoint("breed/\(breed)/images/random")
        case .breedDogImages(let breed):
            return .makeForDogEndpoint("breed/\(breed)/images")
        case .breedCatImages(let breedId):
            return .makeForCatEndpoint("images/search?breed_id=\(breedId)&limit=\(limit)")
        }
    }
}
var animalObjects = [Animal]()
var animalImages = [AnimalImages]()

struct AnimalManager {
    
    weak var delegate: AnimalDelegate?
    
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
                    
                    let endpointThree = Endpoint.breedDogImages(breed: breed).url
                    AF.request(endpointThree).responseDecodable(of: DogImages.self) { response in
                        
                        switch response.result {
                        case .success(let images):
                            animalImagesGenerate(breed: breed, images: images.message)
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
                group.notify(queue: .main) {
                    self.delegate?.addAnimalImage(animalImages: animalImages)
                    self.delegate?.addAnimal(animals: animalObjects)
                }
                
            // print(breeds) // here add local store to Core Data
            case .failure(let error):
                print(error)
            }
        }
        
        let endpointFour = Endpoint.listAllCatBreeds.url
        AF.request(endpointFour).responseDecodable(of: [CatBreed].self) { response in
            
            switch response.result {
            case .success(let cats):
                for cat in cats {
                    group.enter()
                    let endpointFive = Endpoint.breedCatImages(breedId: cat.id).url
                    AF.request(endpointFive).responseDecodable(of: [CatImages].self) { response in
                        
                        switch response.result {
                        case .success(let objects):
                            let images = objects.map{($0.url)}
                            animalImagesGenerate(breed: cat.name, images: images)
                            group.leave()
                        case .failure(let error):
                            print(error)
                        }
                    }
                  
                    let breed = cat.name
                    if let image = cat.image {
                        if let imageURL = image.url {
                            animalGenerate(animals: (breed, imageURL))
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func animalGenerate(animals: (String, String)) {
        let breed = animals.0
        let image = animals.1
        animalObjects.append(Animal(breed: breed, image: image))
        animalObjects.shuffle()
    }
    
    func animalImagesGenerate(breed: String, images: [String]) {
        animalImages.append(AnimalImages(breed: breed, images: images))
        animalImages.shuffle()
    }
}

private extension URL {
    static func makeForDogEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://dog.ceo/api/\(endpoint)")!
    }
    
    static func makeForCatEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.thecatapi.com/v1/\(endpoint)")!
    }
}
