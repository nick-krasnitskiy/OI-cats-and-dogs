//
//  SearchStarWarViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 09.07.2021.
//

import UIKit

class SearchStarWarViewController: UIViewController {
    
    var personManager = PersonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personManager.delegate = self
        personManager.performRequest(with: personManager.personsURL)
        
    }
    
}

extension SearchStarWarViewController: PersonManagerDelegate {
    func getPersons(persons: PersonModel) {
        print(persons)
    }
}
