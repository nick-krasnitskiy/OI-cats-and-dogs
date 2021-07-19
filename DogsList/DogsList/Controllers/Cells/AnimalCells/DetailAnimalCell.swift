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
    
    func configure() {
        DispatchQueue.main.async {
            self.animalImage.image = UIImage(named: "dogTest")
        }
    }
}
