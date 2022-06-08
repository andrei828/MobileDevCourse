//
//  SettingsMenuView.swift
//  UI
//
//  Created by user196345 on 5/19/22.
//

import SwiftUI
import WebKit


struct WebView : UIViewRepresentable {

    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

}


struct SettingsMenuView: View {
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var migration: Migration
    
    @State private var resultAlert = false
    @State private var isPresented = false
    @State private var showingAlert = false
    @State private var isShareSheetShowing = false
    
    func shareButton() {
        isShareSheetShowing.toggle()

        let url = URL(string: "https://pastebin.com/raw/ASb5fSjt")
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    var body: some View {
        VStack {
            Group {
                Spacer()
                Label("Hello \(auth.getCurrentDisplayName())", systemImage: "bolt.fill")
                Spacer()
                Button(action: {
                            self.isPresented.toggle()
                        },label: {
                            Text("About us")
                        }).sheet(isPresented: $isPresented, content: {
                            VStack {
                                WebView(request: URLRequest(url: URL(string: "https://pastebin.com/raw/ASb5fSjt")!))
                                Button("Close") {
                                    isPresented = false
                                }.padding(.bottom, 4)
                            }
                        }).padding(.bottom,2)
                Spacer()
                Button(action:shareButton){
                    HStack{
                        Text("Share with your friends")
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            
            Spacer()
            Button("Restore data from Firestore") {
                showingAlert = true
                let currentEmail = auth.getCurrentEmail()
                let currentName = auth.getCurrentDisplayName()
                resultAlert = migration.restoreDataFromFirestore(authType: auth.authType, email: currentEmail, name: currentName)
            }
            .alert(isPresented: $showingAlert) {
                let currentMessage = resultAlert ? Text("Done") : Text("You need to be authenticated with Google")
                return Alert(title: Text("Result"), message: currentMessage, dismissButton: .default(Text("Got it!")))
            }
            
            Spacer()
            Button("Get local data") {
                print("\(LocalDataStore.getLocalWeightHistory())")
            }
            .alert(isPresented: $showingAlert) {
                let currentMessage = resultAlert ? Text("Done") : Text("You need to be authenticated with Google")
                return Alert(title: Text("Result"), message: currentMessage, dismissButton: .default(Text("Got it!")))
            }
            Group {
                Spacer()
                Button("Add new data") {
                    print("\(LocalDataStore.addNewDateToDabase(value: 55, newDate: Date()))")
                }
                .alert(isPresented: $showingAlert) {
                    let currentMessage = resultAlert ? Text("Done") : Text("You need to be authenticated with Google")
                    return Alert(title: Text("Result"), message: currentMessage, dismissButton: .default(Text("Got it!")))
                }
                Spacer()
                Button("Send to firestore") {
                    let currentEmail = auth.getCurrentEmail()
                    let currentName = auth.getCurrentDisplayName()
                    resultAlert = migration.syncDataWithFirestore(authType: auth.authType, email: currentEmail, name: currentName)
                }
                .alert(isPresented: $showingAlert) {
                    let currentMessage = resultAlert ? Text("Done") : Text("You need to be authenticated with Google")
                    return Alert(title: Text("Result"), message: currentMessage, dismissButton: .default(Text("Got it!")))
                }
            }
            Spacer()
            Button("Sign out") {
                auth.signOut()
            }
            Spacer()
        }
    }
}

struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView()
    }
}
