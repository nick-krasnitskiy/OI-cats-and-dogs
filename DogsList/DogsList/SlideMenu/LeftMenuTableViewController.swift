//
//  LeftMenuTableViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.08.2021.
//

import UIKit

enum SelectedTab: Int {
    case dogList
    case starWars
    case animalList
    case weather
    case news
    case speech
}

class LeftMenuTableViewController: UITableViewController {
    
    let menuOptions = ["Dog List", "Star War", "Animal List", "Weather", "News", "Speech"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - UITableViewDelegate methods

extension LeftMenuTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
        if let selectedTab = SelectedTab(rawValue: indexPath.row) {
            switch selectedTab {
            case .dogList:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openDogList"), object: nil)
            case .starWars:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openStarWars"), object: nil)
            case .animalList:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openAnimalList"), object: nil)
            case .weather:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openWeather"), object: nil)
            case .news:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openNews"), object: nil)
                
            case .speech:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openSpeech"), object: nil)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeMenuViaNotification"), object: nil)
        }
    }
    
}

// MARK: - UITableViewDataSource methods

extension LeftMenuTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = menuOptions[indexPath.row]
        cell.textLabel?.textColor = K.Colors.sectionHeaderColor
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0)
        return cell
    }
}
