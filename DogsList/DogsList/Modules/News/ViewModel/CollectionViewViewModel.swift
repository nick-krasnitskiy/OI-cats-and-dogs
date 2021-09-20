//
//  ArticleViewModel.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 07.09.2021.
//

import UIKit

final class CollectionViewViewModel: CollectionViewViewModelType {
    
    private var articles = [Article]()
    private var newsManager = NewsManager()
    
    func cellViewModel(article: Article) -> CollectionViewCellViewModelType? {
        return CollectionViewCellViewModel(article: article)
    }
    
    func viewModelForSelectedRow(article: Article) -> DetailViewModelType? {
        return DetailViewModel(article: article)
    }
}
