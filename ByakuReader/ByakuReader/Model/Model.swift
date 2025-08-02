//
//  Model.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-08-01.
//


import Appwrite
import Foundation
import AppwriteModels

struct ComicEngagement: Identifiable, Codable {
    let id: String
    let comicId: String
    let userId: String
    let interactionType: String
    let timestamp: Date
    let country: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case comicId, userId, interactionType, timestamp, country, state
    }
    
    init(id: String, comicId: String, userId: String, interactionType: String, timestamp: Date, country: String, state: String) {
        self.id = id
        self.comicId = comicId
        self.userId = userId
        self.interactionType = interactionType
        self.timestamp = timestamp
        self.country = country
        self.state = state
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        comicId = try container.decode(String.self, forKey: .comicId)
        userId = try container.decode(String.self, forKey: .userId)
        interactionType = try container.decode(String.self, forKey: .interactionType)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        country = try container.decode(String.self, forKey: .country)
        state = try container.decode(String.self, forKey: .state)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(comicId, forKey: .comicId)
        try container.encode(userId, forKey: .userId)
        try container.encode(interactionType, forKey: .interactionType)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(country, forKey: .country)
        try container.encode(state, forKey: .state)
    }
}

struct UserComicList: Identifiable, Codable {
    let id: String
    let userId: String
    let comicId: String
    let dateAdded: Date

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case userId, comicId, dateAdded
    }
    
    init(id: String, userId: String, comicId: String, dateAdded: Date) {
        self.id = id
        self.userId = userId
        self.comicId = comicId
        self.dateAdded = dateAdded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        comicId = try container.decode(String.self, forKey: .comicId)
        dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(comicId, forKey: .comicId)
        try container.encode(dateAdded, forKey: .dateAdded)
    }
}

struct ChapterModel: Identifiable, Codable {
    let id: String      // chapterId in your DB
    let comicId: String
    let title: String
    let pageCount: Int
    // Add more fields if needed
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case comicId
        case title
        case pageCount
    }
}

struct UserModel: Identifiable, Codable {
    let id: String
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, email
        
    }
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
    }
}

struct Comic: Identifiable, Codable {
    let id: String
    var title: String
    var subtitle: String?
    var author: [String]
    var genre: [String]
    var description: String
    var imageID: String
    var isComplete: Bool
    var chapter: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case title, subtitle, author, genre, description, imageID, isComplete, chapter
    }
    
    init(id: String, title: String, subtitle: String? = nil, author: [String], genre: [String], description: String, imageID: String, isComplete: Bool, chapter: Int) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.genre = genre
        self.description = description
        self.imageID = imageID
        self.isComplete = isComplete
        self.chapter = chapter
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        author = try container.decode([String].self, forKey: .author)
        genre = try container.decode([String].self, forKey: .genre)
        description = try container.decode(String.self, forKey: .description)
        imageID = try container.decode(String.self, forKey: .imageID)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        chapter = try container.decode(Int.self, forKey: .chapter)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subtitle, forKey: .subtitle)
        try container.encode(author, forKey: .author)
        try container.encode(genre, forKey: .genre)
        try container.encode(description, forKey: .description)
        try container.encode(imageID, forKey: .imageID)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(chapter, forKey: .chapter)
    }
}



struct ReadingProgress: Identifiable, Codable {
    let id: String
    let userId: String
    let comicId: String
    let chapterId: String
    let lastReadAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case userId
        case comicId
        case chapterId
        case lastReadAt
    }
}




