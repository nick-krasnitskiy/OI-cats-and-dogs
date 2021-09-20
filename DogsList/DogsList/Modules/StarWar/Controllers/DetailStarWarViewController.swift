//
//  DetailStarWarViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 12.07.2021.
//

import UIKit

class DetailStarWarViewController: UIViewController {

    let person: Person
    
    init(with person: Person) {
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
        self.view.backgroundColor = K.Colors.backgroundColor
        self.navigationController?.navigationBar.tintColor = .white
        setupLabels()
        addLabels()
        setupConstraints()
    }
    
    private func setupLabels() {
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
        nameLabel.text = self.person.name
        
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.font = .preferredFont(forTextStyle: .headline)
        heightLabel.textColor = .white
        heightLabel.text = "Height: \(self.person.height) sm"
        
        massLabel.translatesAutoresizingMaskIntoConstraints = false
        massLabel.font = .preferredFont(forTextStyle: .headline)
        massLabel.textColor = .white
        massLabel.text = "Mass: \(self.person.mass) kg"
        
        hairColorLabel.translatesAutoresizingMaskIntoConstraints = false
        hairColorLabel.font = .preferredFont(forTextStyle: .headline)
        hairColorLabel.textColor = .white
        hairColorLabel.text = "Hair Color: \(self.person.hair_color)"
        
        skinColorLabel.translatesAutoresizingMaskIntoConstraints = false
        skinColorLabel.font = .preferredFont(forTextStyle: .headline)
        skinColorLabel.textColor = .white
        skinColorLabel.text = "Skin Color: \(self.person.skin_color)"
        
        eyeColorLabel.translatesAutoresizingMaskIntoConstraints = false
        eyeColorLabel.font = .preferredFont(forTextStyle: .headline)
        eyeColorLabel.textColor = .white
        eyeColorLabel.text = "Eye Color: \(self.person.eye_color)"
        
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.font = .preferredFont(forTextStyle: .headline)
        genderLabel.textColor = .white
        genderLabel.text = "Gender: \(self.person.gender)"
        
        self.nameLabel = nameLabel
        self.heightLabel = heightLabel
        self.massLabel = massLabel
        self.hairColorLabel = hairColorLabel
        self.skinColorLabel = skinColorLabel
        self.eyeColorLabel = eyeColorLabel
        self.genderLabel = genderLabel
    }
    
    private func addLabels() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(heightLabel)
        self.view.addSubview(massLabel)
        self.view.addSubview(hairColorLabel)
        self.view.addSubview(skinColorLabel)
        self.view.addSubview(eyeColorLabel)
        self.view.addSubview(genderLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 300),
            heightLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: K.LayoutDimensions.standartDimension),
            massLabel.topAnchor.constraint(equalToSystemSpacingBelow: heightLabel.bottomAnchor, multiplier: K.LayoutDimensions.standartDimension),
            hairColorLabel.topAnchor.constraint(equalToSystemSpacingBelow: massLabel.bottomAnchor, multiplier: K.LayoutDimensions.standartDimension),
            skinColorLabel.topAnchor.constraint(equalToSystemSpacingBelow: hairColorLabel.bottomAnchor, multiplier: K.LayoutDimensions.standartDimension),
            eyeColorLabel.topAnchor.constraint(equalToSystemSpacingBelow: skinColorLabel.bottomAnchor, multiplier: K.LayoutDimensions.standartDimension),
            genderLabel.topAnchor.constraint(equalToSystemSpacingBelow: eyeColorLabel.bottomAnchor, multiplier: K.LayoutDimensions.standartDimension),
            
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
