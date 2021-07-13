//
//  DetailStarWarViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 12.07.2021.
//

import UIKit

class DetailStarWarViewController: UIViewController {

    let person: String// Person
    
    init(with person: String) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var nameLabel: UILabel!
    var heightLabel: UILabel!
    var massLabel: UILabel!
    var hairColorLabel: UILabel!
    var skinColorLabel: UILabel!
    var eyeColorLabel: UILabel!
    var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.3176909506, green: 0.5634241709, blue: 0.5961199444, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white

        let nameLabel = UILabel()
        let heightLabel = UILabel()
        let massLabel = UILabel()
        let hairColorLabel = UILabel()
        let skinColorLabel = UILabel()
        let eyeColorLabel = UILabel()
        let genderLabel = UILabel()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 40.0)
        nameLabel.textColor = .white
        nameLabel.text = "Luke Skywalker" // self.person.name
        
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.font = .preferredFont(forTextStyle: .headline)
        heightLabel.textColor = .white
        heightLabel.text = "Height: 172 sm" // self.person.height
        
        massLabel.translatesAutoresizingMaskIntoConstraints = false
        massLabel.font = .preferredFont(forTextStyle: .headline)
        massLabel.textColor = .white
        massLabel.text = "Mass: 77kg" // self.person.mass
        
        hairColorLabel.translatesAutoresizingMaskIntoConstraints = false
        hairColorLabel.font = .preferredFont(forTextStyle: .headline)
        hairColorLabel.textColor = .white
        hairColorLabel.text = "Hair Color: blond" // self.person.hair_color
        
        skinColorLabel.translatesAutoresizingMaskIntoConstraints = false
        skinColorLabel.font = .preferredFont(forTextStyle: .headline)
        skinColorLabel.textColor = .white
        skinColorLabel.text = "Skin Color: fair" // self.person.skin_color
        
        eyeColorLabel.translatesAutoresizingMaskIntoConstraints = false
        eyeColorLabel.font = .preferredFont(forTextStyle: .headline)
        eyeColorLabel.textColor = .white
        eyeColorLabel.text = "Eye Color: blue" // self.person.eye_color
    
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.font = .preferredFont(forTextStyle: .headline)
        genderLabel.textColor = .white
        genderLabel.text = "Gender: male" // self.person.gender
        
        self.nameLabel = nameLabel
        self.heightLabel = heightLabel
        self.massLabel = massLabel
        self.hairColorLabel = hairColorLabel
        self.skinColorLabel = skinColorLabel
        self.eyeColorLabel = eyeColorLabel
        self.genderLabel = genderLabel
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(heightLabel)
        self.view.addSubview(massLabel)
        self.view.addSubview(hairColorLabel)
        self.view.addSubview(skinColorLabel)
        self.view.addSubview(eyeColorLabel)
        self.view.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 300),
            heightLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1.0),
            massLabel.topAnchor.constraint(equalToSystemSpacingBelow: heightLabel.bottomAnchor, multiplier: 1.0),
            hairColorLabel.topAnchor.constraint(equalToSystemSpacingBelow: massLabel.bottomAnchor, multiplier: 1.0),
            skinColorLabel.topAnchor.constraint(equalToSystemSpacingBelow: hairColorLabel.bottomAnchor, multiplier: 1.0),
            eyeColorLabel.topAnchor.constraint(equalToSystemSpacingBelow: skinColorLabel.bottomAnchor, multiplier: 1.0),
            genderLabel.topAnchor.constraint(equalToSystemSpacingBelow: eyeColorLabel.bottomAnchor, multiplier: 1.0),
            
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            heightLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            massLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            hairColorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            skinColorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            eyeColorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            genderLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}
