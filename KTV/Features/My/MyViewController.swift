//
//  MyViewController.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit

class MyViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.layer.cornerRadius = 10
    }
    
    @IBAction func bookmarkDidTap(_ sender: Any) {
//        self.performSegue(withIdentifier: "bookmark", sender: nil)
    }
    
    @IBAction func favoriteDidTap(_ sender: Any) {
        self.performSegue(withIdentifier: "favorite", sender: nil)
    }
}
