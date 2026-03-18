//
//  MainTabView.swift
//  coLAge
//
//  Created by Developer on 5/5/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .environmentObject(appState)
            
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .environmentObject(appState)
            
            ChatTabView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .environmentObject(appState)
        }
    }
}

#Preview {
    MainTabView().environmentObject(AppState())
}
