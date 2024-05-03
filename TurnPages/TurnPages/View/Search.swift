import SwiftUI
import Combine

struct SearchView: View {
    @StateObject var viewModel = BookViewModel()
    @State private var searchText = ""
    @Binding var isPresented: Bool
    
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
                .listStyle(PlainListStyle()) 
                
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "house")
                        Text("Main Menu")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        // Profile Action
                    }) {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        // Search Action
                    }) {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .padding()
                }
            }
        }
    }
    
    private func fetchBooks() {
        viewModel.fetchBooks(query: searchText)
    }
}

struct BookRow: View {
    let book: Book
    @State private var image: UIImage? = nil // State variable to hold the downloaded image
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .onAppear {
                        loadImage(from: book.thumbnailURL)
                    }
            }
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.authors.joined(separator: ", "))
                    .font(.subheadline)
            }
        }
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                BookImageView(thumbnailURL: book.thumbnailURL)
                
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
        .navigationBarItems(trailing:
                        NavigationLink(destination: AddReviewView(book: book)) {
                            Image(systemName: "plus")
                        })
    }
}

struct BookImageView: View {
    let thumbnailURL: URL?
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 300)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 300)
                    .onAppear {
                        loadImage(from: thumbnailURL)
                    }
            }
        }
    }
    
    private func loadImage(from url: URL?) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

struct AddReviewView: View {
    let book: Book
    @State private var userManager = FdManager()
    @State var review = ""
    @State var rating = ""
    //userManager.addData(user: "Dylan", book: Book)
    var body: some View {
        VStack(spacing: 5) {
            Text("Type Review")
                            .font(.headline)
                            .padding(.top, 20)
            
            TextEditor(text: $review)
                            .frame(minHeight: 100)
                            .border(Color.gray, width: 1)
                            .padding()
                        
                        TextField("Give Rating", text: $rating)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            userManager.addBook(user: "Nicolette", book: book, rate: Int(rating) ?? 10)
                            userManager.addReview(user: "Nicolette", book: book, review: review, rating: Int(rating) ??  10)
                    
                            review = ""
                            rating = ""
                            
                        }, label: {
                            Text("Add Review")
                        })
                        
                    }
                    .padding()
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
        SearchView(isPresented: .constant(false))
    }
}
