//
//  Persons.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 12.07.2021.
//

import UIKit

struct Persons: Codable, Hashable {
    let results: [Person]
}

struct Person: Codable, Hashable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let gender: String
}
