//
//  NewsViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 13.08.2021.
//

import UIKit

protocol NewsViewControllerDelegate: AnyObject {
    func update(category: String)
}

enum NewsSections: Int, CaseIterable {
    case first
    case second
}

class NewsViewController: TabViewControllerTemplate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var dataSource: UICollectionViewDiffableDataSource<NewsSections, Article>?
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    private let size: CGFloat = 1.0
    private let null: CGFloat = 0.0
    private let ten: CGFloat = 10.0
    
    private var newsManager = NewsManager()
    var newsCategory = UserDefaults.standard.string(forKey: "category") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicator()
        update(category: newsCategory)
        
        configureDataSource()
        configureCollectionView()
        
        navigationController?.navigationBar.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        
        newsManager.delegate = self
        searchBar.delegate = self
    
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func hamburgerMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
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
        
        dataSource = UICollectionViewDiffableDataSource<NewsSections, Article>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, news) -> UICollectionViewCell? in
            
            guard let sectionKind = NewsSections(rawValue: indexPath.section) else { return nil }
            
            switch sectionKind {
            case .first:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopNewsCell", for: indexPath) as? TopNewsCell else { fatalError("Cannot create the cell") }
                cell.configure(news: news)
                return cell
            case .second:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestNewsCell", for: indexPath) as? LatestNewsCell else { fatalError("Cannot create the cell") }
                cell.configure(news: news)
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
    
    func addSnapshot(news: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<NewsSections, Article>()
        guard let dataSource = self.dataSource else { return }
        
        DispatchQueue.main.async {
            snapshot.appendSections([.first, .second])
            snapshot.appendItems(Array(news[0...4]),  toSection: .first)
            snapshot.appendItems(Array(news[5..<news.count]),  toSection: .second)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func alertGeenrate(alertTitle: String, alertMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) {(_: UIAlertAction!) in
            self.viewDidLoad()})
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let new = self.dataSource?.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let newsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "NewsDetailVC") as? NewsDetailViewController else { return }
        
        newsDetailViewController.headerNews = new.title
        newsDetailViewController.dateNews = new.publishedAt
        newsDetailViewController.sourceNews = new.source.name
        newsDetailViewController.urlString = new.url
        
        guard let image = new.urlToImage else { return }
        guard let content = new.content else { return }
        
        newsDetailViewController.imageName = image
        newsDetailViewController.textNews = content
        
        self.navigationController?.pushViewController(newsDetailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            newsManager.fetchSearchNews(ketWord: text)
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - DismissKeyboard

extension NewsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(WeatherMapViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - NewsManagerDelegate

extension NewsViewController: NewsManagerDelegate {
    func didFailWithResponce(response: HTTPURLResponse) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertGeenrate(alertTitle: "Failure!", alertMessage: "Response has status unacceptable code: \(response.statusCode)", actionTitle: "Try again")
            
        }
    }
    
    func notResponce() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertGeenrate(alertTitle: "Failure!", alertMessage: "Data not received due to network connection", actionTitle: "Try again")
        }
    }
    
    func didUpdateNews(_ newsManager: NewsManager, news: News) {
        addSnapshot(news: news.articles)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func startActivityIndicator() {
        indicator.center = self.view.center
        indicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        indicator.startAnimating()
        view.addSubview(indicator)
        collectionView.isHidden = true
        searchBar.isHidden = true
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.indicator.hidesWhenStopped = true
            self.indicator.stopAnimating()
            self.collectionView.isHidden = false
            self.searchBar.isHidden = false
        }
    }
}

// MARK: - NewsViewControllerDelegate

extension NewsViewController: NewsViewControllerDelegate {
    func update(category: String) {
        DispatchQueue.main.async {
            self.newsCategory = category
            self.newsManager.fetchTopNews(category: self.newsCategory)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? FilterViewController else { return }
        destination.delegate = self
    }
}
