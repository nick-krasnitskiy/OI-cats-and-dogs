//
//  CollectionViewCellViewModelType.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 08.09.2021.
//

import UIKit

protocol CollectionViewCellViewModelType: class {
    var title: String { get }
    var source: String { get }
    var urlToImage: String? { get }
    var publishedAt: String { get }
}
