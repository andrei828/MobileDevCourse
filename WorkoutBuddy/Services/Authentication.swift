//
//  Authentication.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 25/05/2022.
//

import Foundation
import Firebase
import GoogleSignIn

enum AuthenticationType {
    case Email
    case Google
    case Undefined
}

class Authentication: ObservableObject {
    
    @Published var authType: AuthenticationType
    
    init() {
        FirebaseApp.configure()
        self.authType = .Undefined
        print("Here we start again...")
    }
    
    func getCurrentDisplayName() -> String {
        switch self.authType {
        case .Email:
            return Auth.auth().currentUser?.email ?? "User"
        case .Google:
            return GIDSignIn.sharedInstance()?.currentUser.profile.name ?? "User"
        default:
            return "User"
        }
    }
    
    /**
    Returns the current email adress for the authenticated user
     */
    func getCurrentEmail() -> String {
        switch self.authType {
        case .Email:
            return Auth.auth().currentUser?.email ?? "User not signed in"
        case .Google:
            return GIDSignIn.sharedInstance()?.currentUser.profile.email ?? "User not signed in"
        default:
            return "User not signed in"
        }
    }
    
    /**
    Attempts Sign in and chooses the workflow based on the type variable
     */
    func signIn(email: String, password: String, type: AuthenticationType) {
        
        /** remove hardcoded values */
//        let email = "alexG@gvnjra.com"
//        let password = "123456789"
        
        switch type {
        case .Email:
            signInWithEmail(email, password)
        case .Google:
            signInWithGoogle()
        default:
            print("")
        }
        
    }
    
    /**
    Handles the Sign out action for the Email workflow
     */
    func signInWithEmail(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self?.authType = .Undefined
            } else {
                /**store credentials inside keychain*/
                
                UserDefaults.standard.set("Email", forKey: "WB_AUTH_TYPE")
                UserDefaults.standard.set(email, forKey: "WB_EMAIL")
                UserDefaults.standard.set(password, forKey: "WB_PASS")
                self?.authType = .Email
                
//                let statusType = KeyChain.save(key: "WB_AUTH_TYPE", data: Data(from: "Email"))
//                let statusEmail = KeyChain.save(key: "WB_EMAIL", data: Data(from: email))
//                let statusPassword = KeyChain.save(key: "WB_PASS", data: Data(from: password))
//                if statusType == 0 && statusEmail == 0 && statusPassword == 0 {
//                    self?.authType = .Email
//                    print("Successfully authenticated and added data to the keychain")
//                    
//                    let emailBuffer = KeyChain.load(key: "WB_EMAIL")
//                    let passwordBuffer = KeyChain.load(key: "WB_PASS")
//                    if emailBuffer != nil && passwordBuffer != nil {
//                        let email = emailBuffer!.to(type: String.self)
//                        let password = passwordBuffer!.to(type: String.self)
//                        print(email)
//                        print(password)
//                    }
//                } else {
//                    print("There was an error when adding the data to the keychain")
//                }
            }
        }
    }
    
    /**
    Handles Google Sign in and sets the current presentingViewcontroller
     */
    func signInWithGoogle() {
        if (GIDSignIn.sharedInstance()?.presentingViewController == nil){
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        }
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    /**
    Attempts Sign out regarding the platform
     */
    func signOut() {
        do {
            switch self.authType {
            case .Email:
                try Auth.auth().signOut()
                deleteItemsFromKeychain(type: .Email)
            case .Google:
                GIDSignIn.sharedInstance().signOut()
                deleteItemsFromKeychain(type: .Google)
            default:
                print("User is not signed in")
            }
        
            self.authType = .Undefined
            print("Signed out successfully")
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    /**
    Creates a new user with the given email and password
     */
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("There was an error when creating the user")
                print(error?.localizedDescription ?? "")
            } else {
                print("Successfully created the user")
                self.authType = .Email
            }
        }
    }
    
    /**
     Helper function that removes all credential key-value pairs from keychain
     */
    func deleteItemsFromKeychain(type: AuthenticationType) {
        UserDefaults.standard.removeObject(forKey: "WB_AUTH_TYPE")
        if type == .Email {
            UserDefaults.standard.removeObject(forKey: "WB_EMAIL")
            UserDefaults.standard.removeObject(forKey: "WB_PASS")
        }
        
//        let statusType = KeyChain.delete(key: "WB_AUTH_TYPE")
//        var statusEmail: OSStatus = 0
//        var statusPassword: OSStatus = 0
//
//        if type == .Email {
//            statusEmail = KeyChain.delete(key: "WB_EMAIL")
//            statusPassword = KeyChain.delete(key: "WB_PASS")
//        }
//
//        if statusType == 0 && statusEmail == 0 && statusPassword == 0{
//            print("Successfully removed all data from the keychain")
//        } else {
//            print("There was an error when removing all data from the keychain")
//        }
    }
}
