//
//  DetailViewModelType.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 08.09.2021.
//

import UIKit

protocol DetailViewModelType {
    var title: String { get }
    var source: String { get }
    var url: String { get }
    var urlToImage: String? { get }
    var publishedAt: String { get }
    var content: String? { get }
}
