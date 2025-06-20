//
//  Comic.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-20.
//

import Foundation

class Comic: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String? 
    var author: [String]
    var genre: [String]
    var description: String
    var imageID: String
    var isComplete: Bool
    var chapter: Int

    init(title: String, subtitle: String? = nil, author: [String], genre: [String], description: String, imageID: String, isComplete: Bool, chapter: Int) {
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.genre = genre
        self.description = description
        self.imageID = imageID
        self.isComplete = isComplete
        self.chapter = chapter
    }
}
