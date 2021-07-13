//
//  SearchStarWarViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 09.07.2021.
//

import UIKit

class SearchStarWarViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private var dataSource: DataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    
    var collectionView: UICollectionView! = nil
    let searchBar = UISearchBar(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configuresearchBar()
        configureHierarchy()
        configureDataSource()
        addSnaphot()
        self.navigationItem.title = "Search Star Wars Heroes"
        self.view.backgroundColor = UIColor(red: 0.1469314694, green: 0.259611547, blue: 0.2739216685, alpha: 1)
    }
}

extension SearchStarWarViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        let nib = UINib(nibName: StarWarsCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: StarWarsCell.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configuresearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor(red: 0.3176909506, green: 0.5634241709, blue: 0.5961199444, alpha: 1)
        searchBar.searchTextField.backgroundColor = .white
        view.addSubview(searchBar)
    }
}

extension SearchStarWarViewController {
    
    private func configureHierarchy() {
        let views = ["cv": collectionView!, "searchBar": searchBar] as [String : Any]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
                            withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
                            withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
                            withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(
                            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, personName) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarWarsCell", for: indexPath) as? StarWarsCell else { fatalError("Cannot create the cell") }
            cell.configure(personName: personName)
            return cell
        })
    }
    
    func addSnaphot() {
        guard let dataSource = self.dataSource else { return }
        DispatchQueue.main.async {
            self.snapshot.appendSections([.main])
            self.snapshot.appendItems(["Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa"])
            dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
}

extension SearchStarWarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let person = self.dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = DetailStarWarViewController(with: person)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
