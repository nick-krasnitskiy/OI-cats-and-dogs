//
//  StarWarsCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 12.07.2021.
//

import UIKit

class StarWarsCell: UICollectionViewCell {
    
    @IBOutlet private weak var name: UILabel!
    
    static let reuseIdentifier = "StarWarsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(personName: String) {
        DispatchQueue.main.async {
            self.name.text = personName
        }
    }
}
