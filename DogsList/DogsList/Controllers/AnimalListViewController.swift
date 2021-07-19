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
    
    var columnCount: Int {
        switch self {
        case .first, .third:
            return 1
        case .second:
            return 2
        }
    }
    
    var groupHeight: NSCollectionLayoutDimension {
        switch self {
        case .first:
            return .fractionalHeight(0.2)
        case .second:
            return .fractionalWidth(0.5)
        case .third:
            return .fractionalHeight(0.5)
        }
    }
    
    var groupWidth: NSCollectionLayoutDimension {
        switch self {
        case .first, .third:
            return .fractionalWidth(1.0)
        case .second:
            return .fractionalWidth(0.5)
        }
    }
    
}

class AnimalListViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let indicator = UIActivityIndicatorView(style: .large)
  
    typealias DataSource = UICollectionViewDiffableDataSource<NewSection, String>
    private var dataSource: DataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<NewSection, String>()
    var dogManager = DogManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureCollectionView()
        dogManager.delegate = self
        dogManager.performRequest(with: dogManager.imageURL)
        startActivityIndicator()
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
            
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            
            let heights = sectionType.groupHeight
            let widths = sectionType.groupWidth
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: widths, heightDimension: heights)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            return section
        }
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, imageURL) -> UICollectionViewCell? in
            
            let sectionKind = Section(rawValue: indexPath.section)!
            
            switch sectionKind {
            case .first:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalTopCell", for: indexPath) as? AnimalTopCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            case .second:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalMiddleCell", for: indexPath) as? AnimalMiddleCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            case .third:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalBottomCell", for: indexPath) as? AnimalBottomCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            }
        })
    }
    
    func add(imageURL: [String], animate: Bool = true) {
        guard let dataSource = self.dataSource else { return }
        DispatchQueue.main.async {
            self.snapshot.appendSections([.first, .second, .third])
            self.snapshot.appendItems([imageURL[0]], toSection: .first)
            self.snapshot.appendItems([imageURL[1], imageURL[2]], toSection: .second)
            self.snapshot.appendItems([imageURL[3], imageURL[4], imageURL[5]], toSection: .third)
            dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    func alertGeenrate(alertTitle: String, alertMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {(_: UIAlertAction!) in
                            self.viewDidLoad()})
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - DogManagerDelegate

extension AnimalListViewController: DogManagerDelegate {
    func addDogs(dogImages: [String]) {
        self.add(imageURL: dogImages)
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
        if let breedDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BreedDetailVC") as? BreedDetailController {
            self.navigationController?.pushViewController(breedDetailViewController, animated: true)
        }
    }
}
