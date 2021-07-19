//
//  AnimalTopCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.07.2021.
//

import UIKit

class AnimalTopCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AnimalTopCell"
    
    @IBOutlet private weak var animalImage: UIImageView!
    @IBOutlet private weak var animalBreed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func congigure(urlString: String) {
        DispatchQueue.main.async {
            self.animalBreed.text = String(urlString.split(separator: "/")[3])
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.animalImage.image = image
                    }
                }
            }
        }
    }
}
