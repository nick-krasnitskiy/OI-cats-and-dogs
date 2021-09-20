//
//  News.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 20.08.2021.
//

import Foundation

struct News: Codable, Hashable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
