//
//  TabBarViewController.swift
//  KTV
//
//  Created by dodor on 2023/10/27.
//

import UIKit

class TabBarController: UITabBarController {
    
    weak var videoViewController: VideoViewController?
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension TabBarController: VideoViewControllerContainer {
    func presentCurrentViewController() {
        guard let videoViewController else {
            return
        }
        
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.present(videoViewController, animated: true)
        self.videoViewController = nil
    }
}

extension TabBarController: VideoViewControllerDelegate {
    func videoViewController(_ videoViewController: VideoViewController, yPositionForMinimizeView height: CGFloat) -> CGFloat {
        return self.tabBar.frame.minY - height
    }
    
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController) {
        self.videoViewController = videoViewController
        self.addChild(videoViewController)
        self.view.addSubview(videoViewController.view)
        videoViewController.didMove(toParent: self)
    }
    
    func videoViewControllerNeedsMaximize(_ videoViewController: VideoViewController) {
        self.videoViewController = nil
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
        
        self.present(videoViewController, animated: true)
    }
    
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController) {
        self.videoViewController = nil
        videoViewController.willMove(toParent: nil)
        videoViewController.view.removeFromSuperview()
        videoViewController.removeFromParent()
    }
}
