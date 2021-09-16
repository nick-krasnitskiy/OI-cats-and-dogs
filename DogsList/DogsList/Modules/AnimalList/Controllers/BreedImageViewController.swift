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
    
    var imageName = ""
    private var animalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateImage(urlString: imageName)
        view.backgroundColor = K.Colors.backgroundColor
        self.navigationController?.navigationBar.tintColor = .white
        
        if let scrollView = imageScrollView {
            if let image = animalImage {
                scrollView.setup()
                scrollView.imageContentMode = .aspectFit
                scrollView.initialOffset = .center
                scrollView.display(image: image)
            }
        }
    }
    
    private func generateImage(urlString: String) {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    animalImage = image
                }
            }
        }
    }
}
