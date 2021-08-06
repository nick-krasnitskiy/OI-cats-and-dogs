//
//  WeatherDetailViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 06.08.2021.
//

import UIKit

class WeatherDetailViewController: UITableViewController {
  
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .center
    }
}
