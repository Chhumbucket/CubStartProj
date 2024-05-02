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
}
