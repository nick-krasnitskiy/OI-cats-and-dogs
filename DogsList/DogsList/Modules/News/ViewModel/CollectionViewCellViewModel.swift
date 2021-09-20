//
//  CollectionViewCellViewModel.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 08.09.2021.
//

import UIKit

class CollectionViewCellViewModel: CollectionViewCellViewModelType {
    private var article: Article
    
    var title: String {
        return article.title
    }
    var source: String {
        return article.source.name
    }
    var urlToImage: String? {
        return article.urlToImage
    }
    
    var publishedAt: String {
        return article.publishedAt
    }

    init(article: Article) {
        self.article = article
    }
}
