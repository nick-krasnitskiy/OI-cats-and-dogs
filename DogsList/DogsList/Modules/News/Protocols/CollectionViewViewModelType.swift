//
//  CollectionViewViewModelType.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 08.09.2021.
//

import UIKit

protocol CollectionViewViewModelType {
    func cellViewModel(article: Article) -> CollectionViewCellViewModelType?
    func viewModelForSelectedRow(article: Article) -> DetailViewModelType?
}
