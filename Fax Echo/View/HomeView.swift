//
//  HomeView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager: AuthenticationManager
    @ObservedObject var localCredential: LocalCredential
    @ObservedObject var token: Token
    
    var body: some View {
        
        if authManager.isLoggedIn {
            HomeViewWithTabs(authManager: authManager, localCredential: localCredential, token: token)
            
        } else {
            Login(authManager: authManager, localCredential: localCredential, token: token)
        }
        
    }
}

struct HomeViewWithTabs: View {
    @ObservedObject var authManager: AuthenticationManager
    @ObservedObject var localCredential: LocalCredential
    @ObservedObject var token: Token

    var body: some View {
        TabView {
            Dashboard(token: token, authManager: authManager, localCredential: localCredential)
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

    let token: Token = Token(access_token: "", token_type: "", expires_in: Date(), scope: "", jti: "")
    
    return HomeView(authManager: AuthenticationManager(),
             localCredential: LocalCredential(
                email: "briasdfan@asdkfjas.com",
                password: "kakaka",
                appid: "1234",
                apikey: "abcd",
                userid: "OneTwoThree",
                faxNumber: "123-123-1234"
             ), token: token
    )
}
