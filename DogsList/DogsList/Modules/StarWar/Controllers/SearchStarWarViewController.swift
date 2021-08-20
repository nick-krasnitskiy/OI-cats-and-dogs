//
//  SearchStarWarViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 09.07.2021.
//

import UIKit

class SearchStarWarViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Person>?
    private var personManager = PersonManager()
    
    private var collectionView: UICollectionView! = nil
    private let searchBar = UISearchBar(frame: .zero)
    private var searchHistory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configuresearchBar()
        configureHierarchy()
        configureDataSource()
        self.navigationItem.title = "Search Star Wars Heroes"
        self.view.backgroundColor = K.Colors.backgroundColor
        personManager.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func searchHistoryPressed(_ sender: UIBarButtonItem) {
        let searchHistoryVC = SearchHistoryViewController(with: searchHistory)
        show(searchHistoryVC, sender: nil)
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
        collectionView.backgroundColor = K.Colors.backgroundColor
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configuresearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = K.Colors.backgroundColor
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Enter a hero name"
        view.addSubview(searchBar)
        searchBar.delegate = self
    }
    
    private func alertGeenrate(alertTitle: String, alertMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {(_: UIAlertAction!) in
                            self.viewDidLoad()})
        present(alert, animated: true, completion: nil)
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
        dataSource = UICollectionViewDiffableDataSource<Section, Person>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, person) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarWarsCell", for: indexPath) as? StarWarsCell else { fatalError("Cannot create the cell") }
            cell.configure(personName: person.name)
            return cell
        })
    }
    
    private func addSnaphot(persons: [Person]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
        snapshot.appendSections([.main])
        guard let data = self.dataSource else { return }
        if let foundPersons = persons {
            snapshot.appendItems(foundPersons)
            DispatchQueue.main.async {
                data.apply(snapshot, animatingDifferences: false)
            }
        } else {
            DispatchQueue.main.async {
                data.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchStarWarViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchStarWarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.dataSource else { return  }
        guard let person = data.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = DetailStarWarViewController(with: person)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchStarWarViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            personManager.fetchName(name: searchText)
            searchHistory.append(searchText)
        } else {
            addSnaphot(persons: nil)
        }
    }
    
}

// MARK: - PersonManagerDelegate

extension SearchStarWarViewController: PersonManagerDelegate {
    func getPersons(persons: [Person]) {
        addSnaphot(persons: persons)
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.alertGeenrate(alertTitle: "Error!", alertMessage: error.localizedDescription, actionTitle: "Try again")
        }
    }
    
    func didFailWithResponce(response: HTTPURLResponse ) {
        DispatchQueue.main.async {
            self.alertGeenrate(alertTitle: "Failure!", alertMessage: "Response has status unacceptable code: \(response.statusCode)", actionTitle: "Try again")
            
        }
    }
    
    func notResponce() {
        DispatchQueue.main.async {
            self.alertGeenrate(alertTitle: "Failure!", alertMessage: "Data not received due to network connection", actionTitle: "Try again")
        }
    }
}
