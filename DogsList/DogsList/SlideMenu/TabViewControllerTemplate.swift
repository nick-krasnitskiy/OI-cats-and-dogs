//
//  TabViewControllerTemplate.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.08.2021.
//

import UIKit

class TabViewControllerTemplate: UIViewController {
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(TabViewControllerTemplate.openDogList), name: NSNotification.Name(rawValue: "openDogList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabViewControllerTemplate.openStarWars), name: NSNotification.Name(rawValue: "openStarWars"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(TabViewControllerTemplate.openAnimalList), name: NSNotification.Name(rawValue: "openAnimalList"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(TabViewControllerTemplate.openWeather), name: NSNotification.Name(rawValue: "openWeather"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(TabViewControllerTemplate.openNews), name: NSNotification.Name(rawValue: "openNews"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeMenuViaNotification"), object: nil)
        view.endEditing(true)
    }
    
    @objc func openDogList() {
        tabBarController?.selectedIndex = 0
    }
    
    @objc func openStarWars() {
        tabBarController?.selectedIndex = 1
    }
    
    @objc func openAnimalList() {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func openWeather() {
        tabBarController?.selectedIndex = 3
    }
    
    @objc func openNews() {
        tabBarController?.selectedIndex = 4
    }
}
