//
//  AinalListViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.07.2021.
//

import UIKit

enum NewSection: Int, CaseIterable {
    case first
    case second
    case third
    
    var groupHeight: NSCollectionLayoutDimension {
        switch self {
        case .first:
            return .fractionalHeight(K.LayoutDimensions.standartDimension/5)
        case .second:
            return .fractionalWidth(K.LayoutDimensions.halfDimension)
        case .third:
            return .fractionalHeight(K.LayoutDimensions.halfDimension)
        }
    }
    
    var groupWidth: NSCollectionLayoutDimension {
        switch self {
        case .first, .third:
            return .fractionalWidth(K.LayoutDimensions.standartDimension)
        case .second:
            return .fractionalWidth(K.LayoutDimensions.halfDimension)
        }
    }
    
}

class AnimalListViewController: TabViewControllerTemplate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let indicator = UIActivityIndicatorView(style: .large)
  
    private var dataSource: UICollectionViewDiffableDataSource<NewSection, Animal>?
    private var snapshot = NSDiffableDataSourceSnapshot<NewSection, Animal>()
    private var animalManager = AnimalManager()
    private var images = [AnimalImages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureCollectionView()
        animalManager.delegate = self
        animalManager.performRequest()
        startActivityIndicator()
        
    }
    
    @IBAction func hamburgerMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        
        let nibOne = UINib(nibName: AnimalTopCell.reuseIdentifier, bundle: nil)
        let nibTwo = UINib(nibName: AnimalMiddleCell.reuseIdentifier, bundle: nil)
        let nibThree = UINib(nibName: AnimalBottomCell.reuseIdentifier, bundle: nil)
        
        collectionView.register(nibOne, forCellWithReuseIdentifier: AnimalTopCell.reuseIdentifier)
        collectionView.register(nibTwo, forCellWithReuseIdentifier: AnimalMiddleCell.reuseIdentifier)
        collectionView.register(nibThree, forCellWithReuseIdentifier: AnimalBottomCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            guard let sectionType = NewSection(rawValue: sectionIndex) else { fatalError("unknown section kind") }
        
            let heights = sectionType.groupHeight
            let widths = sectionType.groupWidth
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(K.LayoutDimensions.standartDimension), heightDimension: .fractionalHeight(K.LayoutDimensions.standartDimension))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2*K.LayoutDimensions.standartDimension, leading: 2*K.LayoutDimensions.standartDimension, bottom: 2*K.LayoutDimensions.standartDimension, trailing: 2*K.LayoutDimensions.standartDimension)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: widths, heightDimension: heights)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            return section
        }
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<NewSection, Animal>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, animal) -> UICollectionViewCell? in
            
            let sectionKind = NewSection(rawValue: indexPath.section)!

            switch sectionKind {
            case .first:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalTopCell", for: indexPath) as? AnimalTopCell else { fatalError("Cannot create the cell") }
                cell.configure(animal: animal)
                return cell
            case .second:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalMiddleCell", for: indexPath) as? AnimalMiddleCell else { fatalError("Cannot create the cell") }
                cell.configure(animal: animal)
                return cell
            case .third:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalBottomCell", for: indexPath) as? AnimalBottomCell else { fatalError("Cannot create the cell") }
                cell.configure(animal: animal)
                return cell
            }
        })
    }
    
    func add(animals: [Animal], animate: Bool = true) {
        guard let dataSource = self.dataSource else { return }
        
        DispatchQueue.main.async {
            self.snapshot.appendSections([.first, .second, .third])
            self.snapshot.appendItems([animals[0]],  toSection: .first)
            self.snapshot.appendItems(Array(animals[1...2]), toSection: .second)
            self.snapshot.appendItems(Array(animals[3...animals.count - 1]), toSection: .third)
            dataSource.apply(self.snapshot, animatingDifferences: false)
            self.stopActivityIndicator()
        }
    }
    
    func alertGeenrate(alertTitle: String, alertMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {(_: UIAlertAction!) in
                            self.viewDidLoad()})
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - AnimalManagerDelegate

extension AnimalListViewController: AnimalDelegate {
    func addAnimal(animals: [Animal]) {
        self.add(animals: animals)
    }
    
    func addAnimalImage(animalImages: [AnimalImages]) {
        images = animalImages
    }
    
    func startActivityIndicator() {
        indicator.center = self.view.center
        indicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.1469314694, green: 0.259611547, blue: 0.2739216685, alpha: 1)
        indicator.startAnimating()
        view.addSubview(indicator)
        collectionView.isHidden = true
    }

    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.indicator.hidesWhenStopped = true
            self.indicator.stopAnimating()
            self.collectionView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertGeenrate(alertTitle: "Error!", alertMessage: error.localizedDescription, actionTitle: "Try again")
        }
    }
    
    func didFailWithResponce(response: HTTPURLResponse ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertGeenrate(alertTitle: "Failure!", alertMessage: "Response has status unacceptable code: \(response.statusCode)", actionTitle: "Try again")
            
        }
    }
    
    func notResponce() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertGeenrate(alertTitle: "Failure!", alertMessage: "Data not received due to network connection", actionTitle: "Try again")
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AnimalListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.dataSource else { return }
        guard let breed = data.itemIdentifier(for: indexPath)?.breed else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        for object in images where breed == object.breed {
            let breedDetailViewController = BreedDetailController(with: object)
            self.navigationController?.pushViewController(breedDetailViewController, animated: true)
        }
    }
}
