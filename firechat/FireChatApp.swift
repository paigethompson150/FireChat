//
//  firechatApp.swift
//  firechat
//
//  Created by Paige Thompson on 3/28/24.
//

import SwiftUI
import FirebaseCore // <-- Import Firebase

@main
struct FireChatApp: App {
    
    @State private var authManager: AuthManager

    init() {
        FirebaseApp.configure()
        authManager = AuthManager()
    }

    var body: some Scene {
        WindowGroup {
   
                if authManager.user != nil { // <-- Check if you have a non-nil user (means there is a logged in user)

                    // We have a logged in user, go to ChatView
                    ChatView()
                        .environment(authManager)
                } else {

                    // No logged in user, go to LoginView
                    LoginView()
                        .environment(authManager)
                }
        }
    }
}
