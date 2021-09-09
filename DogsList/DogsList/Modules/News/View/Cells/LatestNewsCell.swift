//
//  LatestNewsCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.08.2021.
//

import UIKit
import SDWebImage

class LatestNewsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LatestNewsCell"

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var date: UILabel!
    
    weak var viewModel: CollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            setup(header: viewModel.title, publisher: viewModel.source, urlToImage: viewModel.urlToImage, publishedAt: viewModel.publishedAt)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup(header: String, publisher: String, urlToImage: String?, publishedAt: String) {
        
        guard let urlString = urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        
        image.sd_setImage(with: url)
        
        source.text = publisher
        date.text = publishedAt.dateConvert(dateString: publishedAt)
        title.text = header
    }
}
