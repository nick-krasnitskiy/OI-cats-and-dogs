//
//  ContainerViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 18.08.2021.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.closeMenu(animated: false)
        }
                
        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "toggleMenu") , object: nil, queue: .main) { [weak self] _ in
            self?.scrollView.contentOffset.x == K.MenuDimensions.nullCoordinate  ? self?.closeMenu() : self?.openMenu()
        }
        
        NotificationCenter.default.addObserver(forName:  NSNotification.Name(rawValue: "closeMenuViaNotification") , object: nil, queue: .main) { [weak self] _ in
            self?.closeMenu()
        }
        
    }
    
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        func closeMenu(animated:Bool = true) {
            scrollView.setContentOffset(CGPoint(x: K.MenuDimensions.leftMenuWidth, y: K.MenuDimensions.nullCoordinate), animated: animated)
        }
        
        func openMenu() {
            scrollView.setContentOffset(CGPoint(x: K.MenuDimensions.nullCoordinate, y: K.MenuDimensions.nullCoordinate), animated: true)
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
