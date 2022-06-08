//
//  Migration.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 09/05/2022.
//

import Foundation
import Firebase

class Migration: ObservableObject {
    
    @Published var firestoreDB = Firestore.firestore()
    
    init() {
        
    }
    
    func getCurrentUserData() -> User {
        return User(weightHistory: LocalDataStore.getLocalWeightHistory())
    }

    func syncDataWithFirestore(authType: AuthenticationType, email: String, name: String) -> Bool {
        if email == "User not signed in" || name == "User not signed in" {
            return false
        }
        
        if authType == .Google {
            do {
                var user = getCurrentUserData()
                user.name = name
                try firestoreDB.collection("users").document(email).setData(from: user)
                return true
            } catch let error {
                print("Error writing user data to Firestore: \(error)")
                return false
            }
        } else {
            return false
        }
    }
    
    func restoreDataFromFirestore(authType: AuthenticationType, email: String, name: String) -> Bool {
        if email == "User not signed in" || name == "User not signed in" {
            return false
        }
        
        if authType == .Google {
            let docRef = firestoreDB.collection("users").document(email)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let result = Result {
                        try document.data(as: User.self)
                       }
                       switch result {
                       case .success(let userHistory):
                           if let weightHistory = userHistory?.weightHistory {
                               // A `User` value was successfully initialized from the DocumentSnapshot.
                               if LocalDataStore.restoreAllDatesFromDatabase(newDates: weightHistory) {
                                   print("Successfully restored data from Firestore...")
                               } else {
                                   print("Failed to update the local storage after Firestore sync...")
                               }
                           } else {
                               // A nil value was successfully initialized from the DocumentSnapshot,
                               // or the DocumentSnapshot was nil.
                               print("Document does not exist...")
                           }
                       case .failure(let error):
                           // A `User` value could not be initialized from the DocumentSnapshot.
                           print("Error decoding user data: \(error)")
                       }
                } else {
                    print("Document does not exist...")
                }
            }

            
            return true
        } else {
            return false
        }
    }
    
    func getDataFromFirestore(authType: AuthenticationType, email: String) -> Bool {
        
        if email == "User not signed in" {
            return false
        }
        
        if authType == .Google {
            // get the data from firestore here
            return true
        } else {
            return false
        }
    }

}
