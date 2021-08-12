//
//  AnimalManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import UIKit
import Alamofire
import CoreData

protocol AnimalDelegate: AnyObject {
    func addAnimal(animals: [Animal])
    func addAnimalImage(animalImages: [AnimalImages])
    func startActivityIndicator()
    func stopActivityIndicator()
    func didFailWithError(error: Error)
    func didFailWithResponce(response: HTTPURLResponse)
    func notResponce()
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
var animalObjectsTwo = [Animal]()

var animalImages = [AnimalImages]()

struct AnimalManager {
    
    weak var delegate: AnimalDelegate?
    
    func performRequest() {
        let group = DispatchGroup()
        
        let endpointOne = Endpoint.listAllDogBreeds.url
        AF.request(endpointOne).responseDecodable(of: DogBreed.self) { response in
            
            switch response.result {
            case .success(let breeds):
                let breeds = breeds.message.keys.map {String($0)}
                
                for breed in breeds {
                    group.enter()
                    
                    let endpointTwo = Endpoint.randomDogBreedImage(breed: breed).url
                    AF.request(endpointTwo).responseDecodable(of: DogImage.self) { response in
                        
                        switch response.result {
                        case .success(let images):
                            animalGenerate(animals: (breed, images.message))
                            saveToDataBase(objects: animalObjects)
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
                    retrieveData(objects: &animalObjectsTwo) 
                    self.delegate?.addAnimalImage(animalImages: animalImages)
                    let animals = animalObjectsTwo.isEmpty ? animalObjects : animalObjectsTwo
                    self.delegate?.addAnimal(animals: animals)
                    
                }
                
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
                            let images = objects.map {($0.url)}
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
                            saveToDataBase(objects: animalObjects) // СОХРАНИЛИ ЗАПРОС С СЕРВЕРА В CD
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
    
    func saveToDataBase(objects: [Animal]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Animals", in: managedContext)!
        
        for animal in objects {
            let animals = NSManagedObject(entity: entity, insertInto: managedContext)
            animals.setValue(animal.breed, forKey: "breed")
            animals.setValue(animal.image, forKey: "image")
        }
        
        if managedContext.hasChanges {
            do {
                try managedContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Animals")))
                try managedContext.save()
                
            } catch let error {
                print("Couldn't save animal to database. \(error)")
            }
        }
    }
    
    func retrieveData( objects: inout [Animal]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Animals")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let breed = data.value(forKey: "breed") as? String, let image = data.value(forKey: "image") as? String {
                    objects.append(Animal(breed: breed, image: image))
                }
            }
        } catch {
            print("Failed")
        }
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
