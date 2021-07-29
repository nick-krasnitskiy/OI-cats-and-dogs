//
//  BreedDetailController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import UIKit

class BreedDetailController: UIViewController {
    
    enum Section {
        case main
    }
    
    let animalImages: AnimalImages
    
    init(with animalImages: AnimalImages) {
        self.animalImages = animalImages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private var dataSource: DataSource!
    
    private var collectionView: UICollectionView! = nil
    private var animalManager = AnimalManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "\(animalImages.breed)"
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
        addSnaphot(images: animalImages.images)
    }
}

extension BreedDetailController {
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        let nib = UINib(nibName: DetailAnimalCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: DetailAnimalCell.reuseIdentifier)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(red: 0.38307597, green: 0.6793843527, blue: 0.7188093509, alpha: 1)
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailAnimalCell", for: indexPath) as? DetailAnimalCell else { fatalError("Cannot create the cell") }
            cell.configure(image: image)
            return cell
        })
    }
    
    func alertGeenrate(alertTitle: String, alertMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {(_: UIAlertAction!) in
                            self.viewDidLoad()})
        present(alert, animated: true, completion: nil)
    }
    
    func addSnaphot(images: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        for image in images {
            snapshot.appendItems([image])
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension BreedDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = self.dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let breedImageViewController = storyBoard.instantiateViewController(withIdentifier: "BreedImageVC") as? BreedImageViewController else { return }
        breedImageViewController.imageName = image
        self.navigationController?.pushViewController(breedImageViewController, animated: true)
    }
}
