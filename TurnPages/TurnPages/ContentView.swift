import SwiftUI

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
}

struct ContentView: View {
    @State private var selectedRatingIndex = 0
    
    let movies: [Movie] = [
        Movie(title: "Inception", rating: 8.8),
        Movie(title: "The Dark Knight", rating: 9.0),
        Movie(title: "Pulp Fiction", rating: 8.9),
    ]
    
    var filteredMovies: [Movie] {
        let selectedRating = Double(selectedRatingIndex + 1)
        return movies.filter { $0.rating >= selectedRating }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Rating", selection: $selectedRatingIndex) {
                    ForEach(0..<10) { index in
                        Text("\(index + 1)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(filteredMovies) { movie in
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
