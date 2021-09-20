//
//  DetailViewModel.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 08.09.2021.
//

import UIKit

class DetailViewModel: DetailViewModelType {
   
    private var article: Article
    
    var title: String {
        return article.title
    }
    
    var source: String {
        return article.source.name
    }
    
    var url: String {
        return article.url
    }
    
    var urlToImage: String? {
        return article.urlToImage
    }
    
    var publishedAt: String {
        return article.publishedAt
    }
    
    var content: String? {
        return article.content
    }
    
    init(article: Article) {
        self.article = article
    }
}
