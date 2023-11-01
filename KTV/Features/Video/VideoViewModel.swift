//
//  VideoViewModel.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import Foundation

@MainActor class VideoViewModel {
    
    private(set) var video: Video?
    var dataChanged: ((Video) -> Void)?
    
    func request() {
        Task {
            do {
                let video = try await DataLoader.load(url: URLDefines.video, for: Video.self)
                self.video = video
                self.dataChanged?(video)
            } catch {
                print("video load failed: \(error.localizedDescription)")
            }
        }
    }
}
