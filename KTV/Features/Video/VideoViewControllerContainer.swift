//
//  VideoViewControllerContainer.swift
//  KTV
//
//  Created by dodor on 2023/11/03.
//

import Foundation

protocol VideoViewControllerContainer {
    var videoViewController: VideoViewController? { get }
    func presentCurrentViewController()
}
