import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
}

struct ContentView: View {
    let movies: [Movie] = [
        Movie(title: "Inception", rating: 8.8),
        Movie(title: "The Dark Knight", rating: 9.0),
        Movie(title: "Pulp Fiction", rating: 8.9),
        // Add more movies here
    ]
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Movies")
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
