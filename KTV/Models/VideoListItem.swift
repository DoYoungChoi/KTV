//
//  VideoListItem.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import Foundation

struct VideoListItem: Decodable {
    let videoId: Int
    let imageUrl: URL
    let title: String
    let playtime: Double
    let channel: String
}
