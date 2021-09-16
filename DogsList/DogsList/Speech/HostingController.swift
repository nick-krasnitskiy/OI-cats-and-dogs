//
//  HostingController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 16.09.2021.
//

import UIKit
import SwiftUI

class HostingController: UIHostingController<ContentView> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ContentView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func hanburgerMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
    }
    
}

struct HostingController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
