//
//  Entensions.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 26.07.2021.
//

import Foundation

public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
  
