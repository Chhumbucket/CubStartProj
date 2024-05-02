import Foundation

struct Book: Identifiable {
    let id: String
    let title: String
    let authors: [String]
    let description: String
    let thumbnailURL: URL?
    let rating: Int
    let ratingCount: Int
}
