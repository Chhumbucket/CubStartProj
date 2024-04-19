import SwiftUI

struct ContentView: View {
    enum Tab {
        case films, reviews, journals
    }
    
    @State private var selectedTab: Tab = .films
    @State private var selectedRatingIndex = 0
    
    let movies: [Movie] = [
        Movie(title: "Inception", rating: 8.8),
        Movie(title: "The Dark Knight", rating: 9.0),
        Movie(title: "Pulp Fiction", rating: 8.9),
        // Add more movies here
    ]
    
    var filteredMovies: [Movie] {
        let selectedRating = Double(selectedRatingIndex + 1)
        return movies.filter { $0.rating >= selectedRating }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("Tab")) {
                    Text("Films").tag(Tab.films)
                    Text("Reviews").tag(Tab.reviews)
                    Text("Personal Journals").tag(Tab.journals)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch selectedTab {
                case .films:
                    FilmListView(movies: filteredMovies)
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
                .background(Color.gray.opacity(0.2))
            }
            .navigationTitle("Letterboxd")
        }
    }
}

struct FilmListView: View {
    let movies: [Movie]
    
    var body: some View {
        List(movies) { movie in
            NavigationLink(destination: MovieDetail(movie: movie)) {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text("Rating: \(movie.rating)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct MovieDetail: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.title)
                .font(.title)
            Text("Rating: \(movie.rating)")
                .foregroundColor(.gray)
                .font(.headline)
            Spacer()
        }
        .padding()
        .navigationTitle(movie.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
}
