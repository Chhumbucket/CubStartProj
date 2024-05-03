import SwiftUI
import Combine

class BookViewModel: ObservableObject {
    var books: [Book] = []
    
    
    init(books: [Book] = [Book]()) {
        self.books = books
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchBooks(query: String) {
        let apiKey = "AIzaSyDKLcNto6UdtuBI2hZsvJGKmdmnooEJBsY"
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(query)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: GoogleBooksResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] response in
                    self?.books = response.items.compactMap {
                        Book(id: $0.id,
                             title: $0.volumeInfo.title,
                             authors: $0.volumeInfo.authors ?? [],
                             description: $0.volumeInfo.description ?? "",
                             thumbnailURL: URL(string: $0.volumeInfo.imageLinks?.thumbnail ?? ""),
                             rating: $0.volumeInfo.rating ?? 0)
                    }
                  })
            .store(in: &cancellables)
    }
}

struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]
}

struct GoogleBookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let rating: Int?
    let ratingCount: Int?
}

struct ImageLinks: Codable {
    let thumbnail: String
}
