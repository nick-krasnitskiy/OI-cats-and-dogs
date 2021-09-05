//
//  Utilities.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 27.08.2021.
//

import UIKit

extension UILabel {
    func dateConvert(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let localDate = dateFormatter.date(from: dateString) else { return "" }
        
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: localDate)
        
    }
}
