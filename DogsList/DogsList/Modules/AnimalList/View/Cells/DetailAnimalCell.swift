//
//  DetailAnimalCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import UIKit

class DetailAnimalCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailAnimalCell"
    
    @IBOutlet private weak var animalImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: String) {
        DispatchQueue.main.async {
            if let url = URL(string: image) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.animalImage.image = image
                    }
                }
                
            }
        }
    }
}
