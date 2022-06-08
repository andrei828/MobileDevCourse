//
//  WorkoutBuddyApp.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 25/05/2022.
//

import SwiftUI
import GoogleSignIn

class AuthenticationDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate {
    
    @ObservedObject var auth = Authentication()
    @ObservedObject var migration = Migration()
    
    /**
     Once the user is obtained we can acces its properties this way user.userID,
     user.authentication.idToken, user.profile.name, user.profile.givenName, user.profile.familyName, user.profile.email
     */
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("\(error.localizedDescription)")
            }
            auth.authType = .Undefined
            return
          }
        
        UserDefaults.standard.set("Google", forKey: "WB_AUTH_TYPE")
        auth.authType = .Google
//        if KeyChain.save(key: "WB_AUTH_TYPE", data: Data(from: "Google")) == 0 {
//            auth.authType = .Google
//            print("Successfully authenticated and added data to the keychain")
//        } else {
//            print("There was an error when adding the data to the keychain")
//        }
        print(user.profile.name!)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GIDSignIn.sharedInstance().clientID = "[NOT_AVAILABLE_ON_PUBLIC_REPO]"
        GIDSignIn.sharedInstance().delegate = self
        
        let authType = UserDefaults.standard.string(forKey: "WB_AUTH_TYPE")
        
        switch authType {
        case "Email":
            let email = UserDefaults.standard.string(forKey: "WB_EMAIL")
            let password = UserDefaults.standard.string(forKey: "WB_PASS")
            self.auth.signIn(email: email ?? "", password: password ?? "", type: .Email)
        case "Google":
            self.auth.authType = .Email
            GIDSignIn.sharedInstance().restorePreviousSignIn()
        default:
            print("User has no credentials stored inside keychain")
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Keep up the good work"
        content.subtitle = "Don't forget to update your data to keep track of your progress"
        content.sound = UNNotificationSound.default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

//        dateComponents.hour = 1727    // 17:27 hours
        
        // Create the trigger as a repeating event.
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
//        // show this notification sixty seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

//         choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

//         add our notification request
        UNUserNotificationCenter.current().add(request)
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
}

@main
struct WorkoutBuddyApp: App {
    
    @UIApplicationDelegateAdaptor(AuthenticationDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.auth)
                .environmentObject(appDelegate.migration)
        }
    }
}
