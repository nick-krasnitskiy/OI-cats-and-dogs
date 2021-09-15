//
//  NewsDetailViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.08.2021.
//

import UIKit
import SafariServices
import SDWebImage

class NewsDetailViewController: UIViewController {
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var header: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    var viewModel: DetailViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        
        guard let urlString = viewModel?.urlToImage else { return }
        guard let url = URL(string: urlString) else { return }
        image.sd_setImage(with: url)
        
        if let viewModel = viewModel {
            self.header.text = viewModel.title
            self.source.text = viewModel.source
            self.date.text = DateConvert.shared.getDate(date: viewModel.publishedAt)
            self.textView.text = viewModel.content
        }
    }
    
    @IBAction func readMorePressed(_ sender: UIButton) {
        
        guard let urlString = viewModel?.url else { return }
        guard let urlNews = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: urlNews)
        present(vc, animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        if let viewModel = viewModel {
            let activityViewController = UIActivityViewController(activityItems: [viewModel.title, viewModel.content ?? "", viewModel.url], applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
