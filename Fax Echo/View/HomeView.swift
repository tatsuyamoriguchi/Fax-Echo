//
//  HomeView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager = AuthenticationManager()

    var body: some View {
        
        Group {
            
            if authManager.isLoggedIn {
                HomeViewWithTabs(authManager: authManager)
            } else {
                Login(authManager: authManager)
            }
            
        }
    }
}

struct HomeViewWithTabs: View {
    @ObservedObject var authManager = AuthenticationManager()
    

    var body: some View {
        TabView {
            Dashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill" )
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.mint
                                , for: .tabBar)
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.mint, for: .tabBar)
            Info()
                .tabItem  {
                    Label("Information", systemImage: "info.circle")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.mint, for: .tabBar)
            Text("Press to Logout")
                .tabItem {
                    Label("Logout", systemImage: "square.and.arrow.up")
                    
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.mint, for: .tabBar)
                .onTapGesture {
                    authManager.isLoggedIn = false
                }
        }
        
    }
}

#Preview {
    HomeView()
}
