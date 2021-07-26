//
//  StarWarsSearchHistoryViewCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.07.2021.
//

import UIKit

class StarWarsSearchHistoryViewCell: UICollectionViewCell {

    @IBOutlet private weak var query: UILabel!
    
    static let reuseIdentifier = "StarWarsSearchHistoryViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(previousQuery: String) {
        DispatchQueue.main.async {
            self.query.text = previousQuery
        }
    }
}
