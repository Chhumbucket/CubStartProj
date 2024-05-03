//
//  UserViewModel.swift
//  TurnPages
//
//  Created by Dylan Chhum on 5/2/24.
//

import SwiftUI
import Observation
import FirebaseCore
import FirebaseFirestore

@Observable class FdManager {
    private let db = Firestore.firestore()
    var users = [User]()
    
    init(users: [User] = [User]()) {
        self.users = users
    }
    
     func fetchAllUsers() async{
        do {
          let querySnapshot = try await db.collection("users").getDocuments()
          var fetchedUsers = [User]()
          for document in querySnapshot.documents {
              do {
                  let fetchedUser = try document.data(as: User.self)
                  fetchedUsers.append(fetchedUser)
              } catch {
                  print("Firestore \(error)")
              }
          }
            users.append(contentsOf: fetchedUsers)
        } catch {
          print("Error getting documents: \(error)")
        }
    }
    
    func addSnapshotListenerToUser() {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
              print("Error fetching documents: \(error!)")
              return
            }
            var fetchedUsers = [User]()
            for document in documents {
                do {
                    let fetchedUser = try document.data(as: User.self)
                    fetchedUsers.append(fetchedUser)
                } catch {
                    print("Firestore \(error)")
                }
            }
            self.users.removeAll()
            self.users.append(contentsOf: fetchedUsers)
          }
    }
    
    func addBook(user: String, book: Book, rate: Int) {
        
        let bookData: [String: Any] = [
            "authors": book.authors,
            "description": book.description,
            "id": book.id,
            "thumbnailUrl": book.thumbnailURL?.absoluteString ?? "",
            "title": book.title,
            "rating": rate
        ]

        let userDocRef = db.collection("users").document(user)

        userDocRef.updateData([
            "savedBooks": FieldValue.arrayUnion([bookData])
        ]) { error in
            if let error = error {
                print("Error adding book to savedBooks: \(error.localizedDescription)")
            } else {
                print("Book added to savedBooks successfully")
            }
        }
    }
    
    func addReview(user: String, book: Book, review: String, rating: Int) {
        
        let reviewData: [String: Any] = [
            "review": review,
            "authors": book.authors,
            "id": book.id,
            "thumbnailUrl": book.thumbnailURL?.absoluteString ?? "",
            "title": book.title,
            "rating": rating
        ]

        let userDocRef = db.collection("users").document(user)

        userDocRef.updateData([
            "reviews": FieldValue.arrayUnion([reviewData])
        ]) { error in
            if let error = error {
                print("Error adding book to reviews: \(error.localizedDescription)")
            } else {
                print("Book added to savedBooks successfully")
            }
        }
    }

}
