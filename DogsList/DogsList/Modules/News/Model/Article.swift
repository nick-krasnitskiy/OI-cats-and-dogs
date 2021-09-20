//
//  Article.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 30.08.2021.
//

import Foundation

struct Article: Codable, Hashable {
    let source: Source
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, title
        case url, urlToImage, publishedAt, content
    }
}
