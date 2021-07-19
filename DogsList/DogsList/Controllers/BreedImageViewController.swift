//
//  BreedImageViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 19.07.2021.
//

import UIKit
import ImageScrollView

class BreedImageViewController: UIViewController {

    @IBOutlet weak var imageScrollView: ImageScrollView!
  
    let myImage = UIImage(named: "dogTest")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.38307597, green: 0.6793843527, blue: 0.7188093509, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        
        if let scrollView = imageScrollView {
            if let image = myImage {
                scrollView.setup()
                scrollView.imageContentMode = .aspectFit
                scrollView.initialOffset = .center
                scrollView.display(image: image)
            }
        }
    }
}
