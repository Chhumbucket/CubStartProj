//
//  User.swift
//  TurnPages
//
//  Created by Dylan Chhum on 5/2/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var reviews: [Review]
    var savedBooks: [SavedBook]
}

struct Review: Codable, Hashable {
    var authors: [String]
    var title: String
    var rating: Int
    var review: String
    var id: String
    var thumbnailUrl: String
}

struct SavedBook: Codable, Identifiable {
    var id: String
    var title: String
    var authors: [String]
    var description: String
    var thumbnailUrl: String
    var rating: Int
}

struct Dummy: Codable, Identifiable {
    var id: Int
    var savedBooks: [SavedBook]
}


