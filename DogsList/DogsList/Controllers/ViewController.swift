//
//  ViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 01.07.2021.
//

import UIKit

enum Section: Int, CaseIterable {
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

class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    private let indicator = UIActivityIndicatorView(style: .large)

    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private var dataSource: DataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
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
        
        let nibOne = UINib(nibName: TopCell.reuseIdentifier, bundle: nil)
        let nibTwo = UINib(nibName: MiddleCell.reuseIdentifier, bundle: nil)
        let nibThree = UINib(nibName: BottomCell.reuseIdentifier, bundle: nil)
        
        collectionView.register(nibOne, forCellWithReuseIdentifier: TopCell.reuseIdentifier)
        collectionView.register(nibTwo, forCellWithReuseIdentifier: MiddleCell.reuseIdentifier)
        collectionView.register(nibThree, forCellWithReuseIdentifier: BottomCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
            
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as? TopCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiddleCell", for: indexPath) as? MiddleCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as? BottomCell else { fatalError("Cannot create the cell") }
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
}

// MARK: - DogManagerDelegate

extension ViewController: DogManagerDelegate {
    func addDogs(dogImages: [String]) {
        self.add(imageURL: dogImages)
    }
    
    func startActivityIndicator() {
        indicator.center = self.view.center
        indicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.6967710582, green: 0.4893499848, blue: 0.1820901042, alpha: 1)
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
        print("Error!: " + error.localizedDescription)
    }

}
