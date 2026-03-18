//
//  coLAgeApp.swift
//  coLAge
//
//  Created by Developer on 5/5/25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isAuthCompleted {
                MainTabView().environmentObject(appState)
            } else {
                ContentView().environmentObject(appState)
            }
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @AppStorage("authCompleted") var isAuthCompleted: Bool = false
    @AppStorage("topCategory") var topCategory: String = ""
    @AppStorage("userId") var uid: String = ""
    @AppStorage("userEmail") var email: String = ""
    
}


let categoryChatIds: [String: String] = [
    "Sports": "group_chat_sports",
    "Nightlife": "group_chat_nightlife",
    "Creativity": "group_chat_creativity"
]
