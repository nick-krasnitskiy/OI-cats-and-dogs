//
//  News.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 20.08.2021.
//

import Foundation

// MARK: - TopNews
struct News: Codable, Hashable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
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

// MARK: - Source
struct Source: Codable, Hashable {
    let id: String?
    let name: String
}
