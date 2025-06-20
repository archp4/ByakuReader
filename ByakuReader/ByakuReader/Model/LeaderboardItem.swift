//
//  LeaderboardItem.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-20.
//

import Foundation

struct LeaderboardItem: Identifiable {
    let id = UUID()
    let rank: Int
    let imageName: String
    let title: String
    let views: String
    let score: String
}
