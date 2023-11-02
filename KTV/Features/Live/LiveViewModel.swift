//
//  LiveViewModel.swift
//  KTV
//
//  Created by dodor on 2023/11/02.
//

import Foundation

enum LiveSortOption {
    case favorite
    case startTime
}

@MainActor class LiveViewModel {
    
    private(set) var items: [Live.Item]?
    private(set) var sortOption: LiveSortOption = .favorite
    var dataChanged: (([Live.Item]) -> Void)?
    
    func request(sort: LiveSortOption) {
        Task {
            do {
                let live = try await DataLoader.load(url: URLDefines.live, for: Live.self)
                let items: [Live.Item]
                if sort == .startTime {
                    items = live.list.reversed()
                } else {
                    items = live.list
                }
                self.items = items
                self.dataChanged?(items)
            } catch {
                print("live data load failed: \(error.localizedDescription)")
            }
        }
    }
}
