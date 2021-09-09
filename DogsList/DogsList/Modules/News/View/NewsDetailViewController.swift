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
            self.date.text = viewModel.publishedAt.dateConvert(dateString: viewModel.publishedAt)
            self.textView.text = viewModel.content
        }
    }
    
    func dateConvert(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let localDate = dateFormatter.date(from: dateString) else { return "" }
        
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: localDate)
        
    }
    
    @IBAction func readMorePressed(_ sender: UIButton) {
        
        guard let urlString = viewModel?.url else { return }
        guard let urlNews = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: urlNews)
        present(vc, animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        let activityViewContoller = UIActivityViewController(activityItems: [self.textView.text], applicationActivities: nil)
        activityViewContoller.popoverPresentationController?.sourceView = self.view
        self.present(activityViewContoller, animated: true, completion: nil)
    }
}
