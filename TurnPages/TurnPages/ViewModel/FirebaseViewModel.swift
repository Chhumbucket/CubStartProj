import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    
    func fetchData() {
        let db = Firestore.firestore()
        
        db.collection("reviews").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reviews: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.reviews = snapshot.documents.compactMap { document in
                        do {
                            // Decode the document data into a Review object
                            let review = try document.data(as: Review.self)
                            return review
                        } catch {
                            print("Error decoding review: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
        }
    }
}
