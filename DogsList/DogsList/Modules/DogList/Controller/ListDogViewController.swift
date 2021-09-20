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

class ListDogViewController: TabViewControllerTemplate {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    private let indicator = UIActivityIndicatorView(style: .large)

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    var dogManager = DogManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        configureDataSource()
        configureCollectionView()
        dogManager.delegate = self
        dogManager.performRequest(with: dogManager.imageURL)
        startActivityIndicator()
    }
    
    @IBAction func hamburgerMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
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
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, imageURL) -> UICollectionViewCell? in
            
            let sectionKind = Section(rawValue: indexPath.section)!
        
            switch sectionKind {
            case .first:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as? TopCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            case .second:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiddleCell", for: indexPath) as? MiddleCell else { fatalError("Cannot create the cell") }
                cell.congigure(urlString: imageURL)
                return cell
            case .third:
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
    
    func alertGeenrate(alertTitle: String, alertMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {(_: UIAlertAction!) in
            self.viewDidLoad()})
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - DogManagerDelegate

extension ListDogViewController: DogManagerDelegate {
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
