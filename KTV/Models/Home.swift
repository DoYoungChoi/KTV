//
//  Home.swift
//  KTV
//
//  Created by dodor on 2023/10/31.
//

import Foundation

struct Home: Decodable {
    let videos: [Video]
    let rankings: [Ranking]
    let recents: [Recent]
    let recommends: [Recommend]
}

extension Home {
    
    struct Video: Decodable {
        let videoId: Int
        let isHot: Bool
        let title: String
        let subtitle: String
        let imageUrl: URL
        let channel: String
        let channelThumbnailURL: URL
        let channelDescription: String
    }
    
    struct Ranking: Decodable {
        let videoId: Int
        let imageUrl: URL
    }
    
    struct Recent: Decodable {
        let imageUrl: URL
        let timeStamp: Double
        let title: String
        let channel: String
    }
    
    struct Recommend: Decodable {
        let videoId: Int
        let imageUrl: URL
        let title: String
        let playtime: Double
        let channel: String
    }
}
