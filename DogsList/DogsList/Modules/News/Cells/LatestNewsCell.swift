//
//  LatestNewsCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.08.2021.
//

import UIKit

class LatestNewsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LatestNewsCell"

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(news: Article) {
        DispatchQueue.main.async {
            guard let urlString = news.urlToImage else { return }
            guard let url = URL(string: urlString) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            guard let realImage = UIImage(data: data) else { return }
            
            self.image.image = realImage
            self.source.text = news.source.name
            self.date.text = self.dateConvert(dateString: news.publishedAt)
            self.title.text = news.title
        }
    }
    
    func dateConvert(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let localDate = dateFormatter.date(from: dateString) else { return "" }
        
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: localDate)
        
    }
}
