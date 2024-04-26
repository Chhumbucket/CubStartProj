import SwiftUI

struct BookListView: View {
    @StateObject var viewModel = BookViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearch: fetchBooks)
                
                List(viewModel.books) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        BookRow(book: book)
                    }
                }
                .navigationTitle("Book Manager")
            }
        }
    }
    
    private func fetchBooks() {
        viewModel.fetchBooks(query: searchText)
    }
}

struct BookRow: View {
    let book: Book
    
    var body: some View {
        HStack {
            if let thumbnailURL = book.thumbnailURL,
               let imageData = try? Data(contentsOf: thumbnailURL),
               let thumbnail = UIImage(data: imageData) {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.authors.joined(separator: ", "))
                    .font(.subheadline)
            }
        }
    }
}

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let thumbnailURL = book.thumbnailURL,
                   let imageData = try? Data(contentsOf: thumbnailURL),
                   let thumbnail = UIImage(data: imageData) {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 300)
                } else {
                    Image(systemName: "book")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 300)
                }
                
                Text(book.title)
                    .font(.title)
                    .padding(.top, 10)
                
                Text("By \(book.authors.joined(separator: ", "))")
                    .font(.subheadline)
                
                Text(book.description)
                    .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle(book.title)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: onSearch) {
                Text("Search")
            }
            .padding(.trailing)
        }
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
