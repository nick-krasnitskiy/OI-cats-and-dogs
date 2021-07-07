//
//  BottomCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 05.07.2021.
//

import UIKit

class BottomCell: UICollectionViewCell {

    static let reuseIdentifier = "BottomCell"
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogBreed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func congigure(urlString: String) {
        
        dogBreed.text = String(urlString.split(separator: "/")[3])
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    dogImage.image = image
                }
            }
        }
    }
}
