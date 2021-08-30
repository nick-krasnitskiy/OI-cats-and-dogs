//
//  TopNewsCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.08.2021.
//

import UIKit

class TopNewsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TopNewsCell"
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(news: Article) {
        guard let urlString = news.urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        
        image.load(url: url)
        source.text = news.source.name
        date.text = date.dateConvert(dateString: news.publishedAt)
        title.text = news.title
    }
}
