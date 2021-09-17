//
//  Constants.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 15.09.2021.
//

import UIKit

struct K {
    struct Animation {
        static let duration = 0.5
        static let delay = 0.1
        static let transformSort: CGFloat = 0.1
        static let transformCheck: CGFloat = 0.4
    }
    
    struct LayoutDimensions {
        static let standartDimension: CGFloat = 1.0
        static let halfDimension: CGFloat = 0.5
        static let nullDimension: CGFloat = 0.0
        static let tenDimension: CGFloat = 10.0
        static let twentyDimension: CGFloat = 20.0
        static let fortyDimension: CGFloat = 40.0
    }
    
    struct MenuDimensions {
        static let nullCoordinate: CGFloat = 0.0
        static let leftMenuWidth: CGFloat = 260
    }
    
    struct Colors {
        static let backgroundColor = UIColor(red: 0.3176909506, green: 0.5634241709, blue: 0.5961199444, alpha: 1)
        static let indicatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let sectionHeaderColor = UIColor(red: 0.1443712413, green: 0.2595478296, blue: 0.2738721073, alpha: 1)
    }
    
    struct Fonts {
        static let sectionTitleFont = UIFont(name: "Hiragino Sans W6", size: 20)
    }
   
}
