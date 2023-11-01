//
//  BookmarkViewModel.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import Foundation

@MainActor class BookmarkViewModel {
    
    private(set) var channels: [Bookmark.Channel]?
    var dataChanged: (() -> Void)?
    
    func request() {
        Task {
            do {
                let data = try await DataLoader.load(url: URLDefines.bookmark, for: Bookmark.self)
                self.channels = data.channels
                self.dataChanged?()
            } catch {
                print("bookmark list load failed: \(error.localizedDescription)")
            }
        }
    }
}
