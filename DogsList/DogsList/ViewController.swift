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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
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
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in
            
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as? TopCell else { fatalError("Cannot create the cell") }
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiddleCell", for: indexPath) as? MiddleCell else { fatalError("Cannot create the cell") }
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as? BottomCell else { fatalError("Cannot create the cell") }
                return cell
            }
        })
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.first, .second, .third])
        snapshot.appendItems([1], toSection: .first)
        snapshot.appendItems(Array(2...3), toSection: .second)
        snapshot.appendItems(Array(4...6), toSection: .third)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

