//
//  SectionHeader.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.08.2021.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let reuserIdentifier = "SectionHeader"
    
    let stackView = UIStackView()
    let title = UILabel()
    let sortButton = UIButton()
    
    var sortButtonDidTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeElements()
        setupConstraints()
    }
    
    private func customizeElements() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        title.textColor = #colorLiteral(red: 0.1443712413, green: 0.2595478296, blue: 0.2738721073, alpha: 1)
        title.font = UIFont(name: "Hiragino Sans", size: 25)
        title.font = UIFont.boldSystemFont(ofSize: 25)
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .medium)
        
        let infoImage = UIImage(systemName: "arrow.down", withConfiguration: largeConfig)?.withTintColor(#colorLiteral(red: 0.1443712413, green: 0.2595478296, blue: 0.2738721073, alpha: 1), renderingMode: .alwaysOriginal)
        sortButton.setImage(infoImage, for: .normal)
        
        let infoImageTwo = UIImage(systemName: "arrow.up", withConfiguration: largeConfig)?.withTintColor(#colorLiteral(red: 0.1443712413, green: 0.2595478296, blue: 0.2738721073, alpha: 1), renderingMode: .alwaysOriginal)
        sortButton.setImage(infoImageTwo, for: .selected)
        
        sortButton.addAction(UIAction(handler: { [unowned self] (_) in
            self.sortButtonDidTapped?()
            
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                self.sortButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (_) in
                self.sortButton.isSelected = !sortButton.isSelected
                UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                    self.sortButton.transform = .identity
                }, completion: nil)
            }
        }), for: .touchUpInside)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(sortButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
