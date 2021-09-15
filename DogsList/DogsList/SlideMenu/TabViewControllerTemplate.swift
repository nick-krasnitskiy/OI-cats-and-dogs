//
//  TabViewControllerTemplate.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.08.2021.
//

import UIKit

class TabViewControllerTemplate: UIViewController {
    
    override func viewDidLoad() {

        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "openDogList") , object: nil, queue: .main) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 0
        }
        
        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "openStarWars") , object: nil, queue: .main) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 1
        }

        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "openAnimalList") , object: nil, queue: .main) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 2
        }

        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "openWeather") , object: nil, queue: .main) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 3
        }

        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "openNews") , object: nil, queue: .main) { [weak self] _ in
            self?.tabBarController?.selectedIndex = 4
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeMenuViaNotification"), object: nil)
        view.endEditing(true)
    }
}
