//
//  Bookmark.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import Foundation

struct Bookmark: Decodable {
    let channels: [Channel]
}

extension Bookmark {
    struct Channel: Decodable {
        let name: String
        let id: Int
        let thumbnail: URL
        
        enum CodingKeys: String, CodingKey {
            case name = "channel"
            case id = "channelId"
            case thumbnail
        }
    }
}
