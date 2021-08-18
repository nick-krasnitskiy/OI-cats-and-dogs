//
//  NewsViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 13.08.2021.
//

import UIKit

enum NewsSections: Int, CaseIterable {
    case first
    case second
}

class NewsViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<NewsSections, Int>?
    private var snapshot = NSDiffableDataSourceSnapshot<NewsSections, Int>()
    
    private let size: CGFloat = 1.0
    private let null: CGFloat = 0.0
    private let ten: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureCollectionView()
        addSnapshot()
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        
        let nibOne = UINib(nibName: TopNewsCell.reuseIdentifier, bundle: nil)
        let nibTwo = UINib(nibName: LatestNewsCell.reuseIdentifier, bundle: nil)
        
        collectionView.register(nibOne, forCellWithReuseIdentifier: TopNewsCell.reuseIdentifier)
        collectionView.register(nibTwo, forCellWithReuseIdentifier: LatestNewsCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuserIdentifier)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            guard let sectionType = NewsSections(rawValue: sectionIndex) else { fatalError("unknown section kind") }
            
            switch sectionType {
            case .first:
                return self.createTopNewsSection()
            case .second:
                return self.createLatesNewsSection()
            }
        }
        return layout
    }
    
    func createTopNewsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(size),
                                              heightDimension: .fractionalHeight(size))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: null, leading: null, bottom: ten, trailing: 4*ten)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(size),
                                                     heightDimension: .fractionalHeight(size/2))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: ten, leading: 2*ten, bottom: 2*ten, trailing: 2*ten)
        
        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]
        
        return layoutSection
    }
    
    func createLatesNewsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(size),
                                              heightDimension: .fractionalHeight(size))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: null, leading: null, bottom: null, trailing: null)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(size),
                                               heightDimension: .fractionalWidth(size/2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(2*ten)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: ten, leading: 2*ten, bottom: ten, trailing: 2*ten)
        
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHEaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(size), heightDimension: .estimated(1))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHEaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<NewsSections, Int>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in
            
            guard let sectionKind = NewsSections(rawValue: indexPath.section) else { return nil }
            
            switch sectionKind {
            case .first:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopNewsCell", for: indexPath) as? TopNewsCell else { fatalError("Cannot create the cell") }
                return cell
            case .second:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestNewsCell", for: indexPath) as? LatestNewsCell else { fatalError("Cannot create the cell") }
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuserIdentifier, for: indexPath) as? SectionHeader else { return nil }
            
            guard let sectionType = NewsSections(rawValue: indexPath.section) else { fatalError("unknown section kind") }
            
            switch sectionType {
            case .first:
                sectionHeader.title.text = "Top 5 news"
            case .second:
                sectionHeader.title.text = "Latest news"
            }
            return sectionHeader
            
        }
    }
    
    func addSnapshot() {
        guard let dataSource = self.dataSource else { return }
        DispatchQueue.main.async {
            self.snapshot.appendSections([.first, .second])
            self.snapshot.appendItems(Array(0..<5),  toSection: .first)
            self.snapshot.appendItems(Array(6..<100),  toSection: .second)
            dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
}
