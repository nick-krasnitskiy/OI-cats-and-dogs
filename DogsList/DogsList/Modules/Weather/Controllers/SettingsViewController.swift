//
//  SettingsViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 11.08.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: WeatherMapViewControllerDelegate?
   
    @IBOutlet private weak var controll: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Settings"
        controll.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "index")
    }
    
    @IBAction func tempControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            saveSettings(tempMetric: "metric", index: 0)
            delegate?.update(unit: "metric")
        } else {
            saveSettings(tempMetric: "imperial", index: 1)
            delegate?.update(unit: "imperial")
        }
    }
    
    func saveSettings(tempMetric: String, index: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(tempMetric, forKey: "temperature metric")
        defaults.setValue(index, forKey: "index")
    }
}
