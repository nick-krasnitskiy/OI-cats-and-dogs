//
//  MiddleCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 05.07.2021.
//

import UIKit

class MiddleCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MiddleCell"
    
    @IBOutlet private weak var dogImage: UIImageView!
    @IBOutlet private weak var dogBreed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func congigure(urlString: String) {
        DispatchQueue.main.async {
            self.dogBreed.text = String(urlString.split(separator: "/")[3])
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.dogImage.image = image
                    }
                }
            }
        }
    }
}
