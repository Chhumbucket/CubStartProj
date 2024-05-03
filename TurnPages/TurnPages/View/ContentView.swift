import SwiftUI

struct ContentView: View {
    enum Tab {
        case books, reviews
    }
    
    @State private var selectedTab: Tab = .books
    @State private var selectedRatingIndex = 0
    @State private var showingSearchView = false
    @State private var showingUserView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("Tab")) {
                    Text("Books").tag(Tab.books)
                    Text("Reviews").tag(Tab.reviews)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch selectedTab {
                case .books:
                    BookView()
                case .reviews:
                    UserReviewView()

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

// Maybe it navigationview so you can click and read // add borders around reviews
//Add later  
struct UserReviewView: View {
    @State private var userManager = FdManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(userManager.users) { user in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.name)
                            .font(.headline)
                        
                        ForEach(user.reviews, id: \.self) { review in
                            HStack(spacing: 12) {
                                // Display thumbnail image using AsyncImage
                                AsyncImage(url: URL(string: review.thumbnailUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    case .failure:
                                        Image(systemName: "book")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Book: \(review.title)")
                                        .font(.subheadline)
                                    
                                    Text("Author: \(review.authors.joined(separator: ", "))")
                                        .font(.subheadline)
                                    
                                    Text("Rating: \(review.rating)")
                                        .font(.subheadline)
                                    
                                    Text("Review: \(review.review)")
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true) // Allow multiline text
                                }
                                .padding(.trailing, 8)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .padding(.top)
        }
        .onAppear {
            userManager.addSnapshotListenerToUser()
        }
    }
}




struct BookView: View {
    @State private var userManager = FdManager()
    
    var body: some View {
        List(userManager.savedBooks) { book in
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
        .onAppear {
            userManager.addSnapshotListenerToBook()
        }
    }
}

struct BookDetail: View {
    let book: SavedBook
    
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
