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
    
    var imageName = ""
    var headerNews = ""
    var sourceNews = ""
    var dateNews = ""
    var textNews = ""
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        
        guard let url = URL(string: imageName) else { return }
        image.sd_setImage(with: url)
        
        self.header.text = headerNews
        self.source.text = sourceNews
        self.date.text = self.dateConvert(dateString: dateNews)
        self.textView.text = textNews
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
        
        guard let urlNews = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: urlNews)
        present(vc, animated: true)
    }
    
}
