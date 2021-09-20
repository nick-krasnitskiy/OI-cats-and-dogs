//
//  SearchHistoryViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.07.2021.
//

import UIKit

class SearchHistoryViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    let searchHistory: [String]
    
    init(with searchHistory: [String]) {
        self.searchHistory = searchHistory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        addSnaphot(searchHistory: searchHistory.removingDuplicates())
        navigationItem.title = "Search History"
        navigationController?.navigationBar.tintColor = .white
    }
}

private extension SearchHistoryViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let `self` = self else { return nil }
            guard let data = self.dataSource else { return nil }
            let selectedItem = data.itemIdentifier(for: indexPath)
            return self.deleteItemOnSwipe(item: selectedItem!)
        }
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        let nib = UINib(nibName: StarWarsSearchHistoryViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: StarWarsSearchHistoryViewCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, query) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarWarsSearchHistoryViewCell", for: indexPath) as? StarWarsSearchHistoryViewCell else { fatalError("Cannot create the cell") }
            cell.configure(previousQuery: query)
            return cell
        })
    }
    
    private func deleteItemOnSwipe(item: String) -> UISwipeActionsConfiguration? {
        let actionHandler: UIContextualAction.Handler = { _, _, completion in
            completion(true)
            guard let data = self.dataSource else { return  }
            var snapShot = data.snapshot()
            snapShot.deleteItems([item])
            data.apply(snapShot)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: actionHandler)
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func addSnaphot(searchHistory: [String]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        guard let data = self.dataSource else { return  }
        if let queries = searchHistory {
            DispatchQueue.main.async {
                snapshot.appendItems(queries)
                data.apply(snapshot, animatingDifferences: false)
            }
        } else {
            DispatchQueue.main.async {
                data.apply(snapshot, animatingDifferences: false)
            }
        }
    }
}
