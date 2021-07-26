//
//  Animal.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import UIKit

struct DogBreed: Codable {
    let message: [String: [String]]
    let status: String
}

struct DogImage: Codable {
    let message: String
    let status: String
}

struct Animal: Codable, Hashable {
    let breed: String
    let image: String
}
