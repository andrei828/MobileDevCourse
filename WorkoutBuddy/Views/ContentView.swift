//
//  ContentView.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 25/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var migration: Migration
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var hasTimeElapsed = false
    @State private var shouldAnimate = false
    @State private var animate = true
    let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
    @State var leftOffset: CGFloat = -100
    @State var rightOffset: CGFloat = 100
    
    var body: some View {
        if auth.authType == .Undefined {

            TextField("Enter your email", text: $email)
                .font(Font.system(size: 20, weight: .medium))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 80, alignment: .center)
                .padding([.leading, .trailing], 40)
                
            SecureField("Enter your password", text: $password)
                .font(Font.system(size: 20, weight: .medium))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 80, alignment: .center)
                .padding([.leading, .trailing], 40)
            
            Button(action: {
                auth.signIn(email: email, password: password, type: .Email)
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "iphone")
                    Text("Sign in")
                        
                }
                
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 50, alignment: .center)
                .padding([.leading, .trailing], 5)
                .border(Color.purple, width: 1)
            
            GoogleSignInButton()
                .onTapGesture {
                    auth.signIn(email: "", password: "", type: .Google)
                }
                .frame(height: 30, alignment: .center)
                .padding([.leading, .trailing], 50)
                
        } else if (hasTimeElapsed){
            TabView {
                WeightMenuView()
                    .tabItem {
                        Text("Weight")
                        Image(systemName: "gauge")
                    }
                WorkoutMenuView()
                    .tabItem {
                        Text("Workout")
                        Image(systemName: "figure.walk")
                    }
                GymsMenuView()
                    .tabItem {
                        Text("Gyms")
                        Image(systemName: "map")
                    }
                SettingsMenuView()
                    .tabItem {
                        Text("Settings")
                        Image(systemName: "gearshape")
                    }
            }
            .onAppear {
                self.shouldAnimate = false
            }
            .animation(.easeInOut) // 2
            .transition(.slide) // 3
        } else if (animate == true){
            VStack {
                Spacer()
                Section {
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever())
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
                    }
                }
                Spacer()
            }
            .onAppear {
                self.delayText()
                self.shouldAnimate = true
            }
            .animation(.easeInOut) // 2
            .transition(.slide)
        }
    }
    
    private func delayText() {
        // Delay of 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hasTimeElapsed = true
            self.shouldAnimate = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
