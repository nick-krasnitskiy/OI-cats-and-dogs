//
//  Dog.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 06.07.2021.
//

import UIKit

struct Dog: Codable, Hashable {
    var message: [String]  
    var status: String

    let identifier: UUID = UUID()

    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        lhs.identifier == rhs.identifier
    }

}
