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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    private let indicator = UIActivityIndicatorView(style: .large)
    private var collectionView: UICollectionView! = nil
    private var animalManager = AnimalManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicator()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(K.Dimensions.standartDimension),
                                              heightDimension: .fractionalWidth(K.Dimensions.standartDimension/2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(K.Dimensions.standartDimension),
                                               heightDimension: .fractionalWidth(K.Dimensions.standartDimension/2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10*K.Dimensions.standartDimension, leading: 10*K.Dimensions.standartDimension, bottom: 10*K.Dimensions.standartDimension, trailing: 10*K.Dimensions.standartDimension)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        let nib = UINib(nibName: DetailAnimalCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: DetailAnimalCell.reuseIdentifier)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = K.Colors.backgroundColor
        view.addSubview(collectionView)
        view.addSubview(indicator)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell? in
            
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
        guard let data = self.dataSource else { return }
        data.apply(snapshot, animatingDifferences: false)
        stopActivityIndicator()
    }
    
    func startActivityIndicator() {
        indicator.center = self.view.center
        indicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        indicator.startAnimating()
    }

    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.indicator.hidesWhenStopped = true
            self.indicator.stopAnimating()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension BreedDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.dataSource else { return }
        guard let image = data.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let breedImageViewController = storyBoard.instantiateViewController(withIdentifier: "BreedImageVC") as? BreedImageViewController else { return }
        breedImageViewController.imageName = image
        self.navigationController?.pushViewController(breedImageViewController, animated: true)
    }
}
