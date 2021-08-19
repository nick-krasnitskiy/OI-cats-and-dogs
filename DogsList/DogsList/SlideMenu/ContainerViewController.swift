//
//  ContainerViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.08.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    let leftMenuWidth:CGFloat = 260
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async() {
            self.closeMenu(animated: false)
        }
                
        NotificationCenter.default.addObserver(self, selector: #selector(ContainerViewController.toggleMenu), name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContainerViewController.closeMenuViaNotification), name: NSNotification.Name(rawValue: "closeMenuViaNotification"), object: nil)
    }
    
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc func toggleMenu() {
            scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
        }
        
        @objc func closeMenuViaNotification() {
            closeMenu()
        }
        
        func closeMenu(animated:Bool = true) {
            scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
        }
        
        func openMenu() {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }

    extension ContainerViewController : UIScrollViewDelegate {
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            scrollView.isPagingEnabled = true
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            scrollView.isPagingEnabled = false
        }
}
