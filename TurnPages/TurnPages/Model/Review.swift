//
//  Review.swift
//  TurnPages
//
//  Created by Dylan Chhum on 5/1/24.
//

import Foundation

struct Review:Identifiable, Decodable {
    let id: String?
    let bookId: String
    let review: String
    let reviewCount: Int
}

