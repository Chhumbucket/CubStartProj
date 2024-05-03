import Foundation

struct Book: Identifiable, Codable {
    var id: String
    var title: String
    var authors: [String]
    var description: String
    var thumbnailURL: URL?
    var rating: Int
}

struct SavedBook: Identifiable, Codable {
    var id: String
    var title: String
    var authors: [String]
    var description: String
    var thumbnailUrl: String

}
