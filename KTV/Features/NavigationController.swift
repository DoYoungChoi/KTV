//
//  NavigationController.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
