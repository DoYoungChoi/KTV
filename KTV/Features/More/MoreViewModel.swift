//
//  MoreViewModel.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import Foundation

struct MoreViewModel {
    
    let items: [MoreItem] = [
        .init(title: "화질 변경", description: "자동 720"),
        .init(title: "자동 재생", description: "On"),
        .init(title: "공유하기", description: nil),
        .init(title: "신고하기", description: nil)
    ]
}

struct MoreItem {
    let title: String
    let description: String?
}
