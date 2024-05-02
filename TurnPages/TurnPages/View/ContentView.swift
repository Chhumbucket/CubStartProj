import SwiftUI

struct ContentView: View {
    enum Tab {
        case books, reviews, journals
    }
    
    @State private var selectedTab: Tab = .books
    @State private var selectedRatingIndex = 0
    @State private var showingSearchView = false
    @State private var showingUserView = false
    
    // Mock array of books
    let books: [Book] = []
    
    var filteredBooks: [Book] {
        let selectedRating = Double(selectedRatingIndex + 1)
        return books.filter { $0.rating >= Int(selectedRating) }
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
                    BookView(books: filteredBooks)
                case .reviews:
                    userReviewView()
                case .journals:
                    JournalView()
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // Action for Main Menu button
                    }) {
                        Image(systemName: "house")
                        Text("Main Menu")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showingUserView = true
                    }) {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .padding()
                    .sheet(isPresented: $showingUserView) {
                        // Display UserView here
                        UserView(isPresented: $showingUserView)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingSearchView = true
                    }) {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .padding()
                    .sheet(isPresented: $showingSearchView) {
                        // Display BookListView here
                        SearchView(isPresented: $showingSearchView)
                    }
                }
                .background(Color.gray.opacity(0.2))
            }
            .background(Color(hex: "#E3DCD5"))
            .navigationTitle("Quotify")
        }
    }
}

struct userReviewView: View {
    @State private var userManager = FdManager()
    
    var body: some View {
            List(userManager.users) { user in
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.name)
                        .font(.headline)
                    
                    ForEach(user.reviews, id: \.self) { review in
                        VStack(alignment: .leading) {
                            Text("Book: \(review.book)")
                                .font(.subheadline)
                            Text("Author: \(review.author)")
                                .font(.subheadline)
                            Text("Rating: \(review.rating)")
                                .font(.subheadline)
                            Text("Review: \(review.review)")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
            .task {
                await userManager.fetchAllUsers()
            }
        }
    }


struct BookView: View {
    let books: [Book]
    
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
    let book: Book
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
