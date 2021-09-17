//
//  Extensions.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.09.2021.
//

import Foundation

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
