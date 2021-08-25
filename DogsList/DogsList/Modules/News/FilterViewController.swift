//
//  FilterViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 25.08.2021.
//

import UIKit

class FilterViewController: UITableViewController {
    
    weak var delegate: NewsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "News category"
    }

    @IBAction func checkBoxTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
        
        switch sender.tag {
        case 1:
            saveSettings(category: "business")
            delegate?.update(category: "business")
        case 2:
            saveSettings(category: "entertainment")
            delegate?.update(category: "entertainment")
        case 3:
            saveSettings(category: "general")
            delegate?.update(category: "general")
        case 4:
            saveSettings(category: "health")
            delegate?.update(category: "health")
        case 5:
            saveSettings(category: "science")
            delegate?.update(category: "science")
        case 6:
            saveSettings(category: "sports")
            delegate?.update(category: "sports")
        case 7:
            saveSettings(category: "technology")
            delegate?.update(category: "technology")
        default:
            print("")
        }
    }
    
    func saveSettings(category: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(category, forKey: "category")
    }
}
