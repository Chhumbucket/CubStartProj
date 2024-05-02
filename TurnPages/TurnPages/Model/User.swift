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
}

struct Review: Codable, Hashable {
    var author: String
    var book: String
    var rating: Int
    var review: String
}



