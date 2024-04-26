import SwiftUI

struct ContentView: View {
    enum Tab {
        case books, reviews, journals
    }
    
    @State private var selectedTab: Tab = .books
    @State private var selectedRatingIndex = 0
    @State private var isProfileViewActive = false
    
    let books: [TestBook] = [
        TestBook(title: "Wonder", rating: 8.8),
        TestBook(title: "The Great Gatsby", rating: 9.0),
        TestBook(title: "Harry Potter", rating: 9.9),
        // Add more books here
    ]
    
    var filteredBooks: [TestBook] {
        let selectedRating = Double(selectedRatingIndex + 1)
        return books.filter { $0.rating >= selectedRating }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("Tab")) {
                    Text("Books").tag(Tab.books)
                    Text("Reviews").tag(Tab.reviews)
                    Text("Personal Journal").tag(Tab.journals)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch selectedTab {
                case .books:
                    FilmListView(books: filteredBooks)
                case .reviews:
                    Text("Reviews Tab Content")
                case .journals:
                    Text("Personal Journals Tab Content")
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // Main Menu Action
                    }) {
                        Image(systemName: "house")
                        Text("Main Menu")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        self.isProfileViewActive = true
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
                NavigationLink(destination: UserView(), isActive: $isProfileViewActive) { EmptyView() }
            }
            .background(Color(hex: "#E3DCD5"))
            .navigationTitle("Quotify")
        }
    }
}

struct FilmListView: View {
    let books: [TestBook]
    
    var body: some View {
        List(books) { book in
            NavigationLink(destination: BookDetail(book: book)) {
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Rating: \(String(format: "%.1f", book.rating))")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
            .listRowBackground(Color(hex: "774E32")) // Color for each list row
        }
        .background(Color.clear)
    }
}

struct BookDetail: View {
    let book: TestBook
    
    var body: some View {
        VStack {
            Text(book.title)
                .font(.title)
            Text("Rating: \(String(format: "%.1f", book.rating))")
                .foregroundColor(.gray)
                .font(.headline)
            Spacer()
        }
        .padding()
        .navigationTitle(book.title)
    }
}

struct ContentView_Previews0: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TestBook: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
}
