//
//  ContentView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var authManager: AuthenticationManager
    @ObservedObject var localCredential: LocalCredential

    
    var body: some View {
        
        Group {
            
            if authManager.isLoggedIn == true {
                HomeView(authManager: authManager, localCredential: localCredential)
                
                let _ = print("appid from ContantView() to HomeView(): \(localCredential.appid)")
            } else {
                Login(authManager: authManager, localCredential: localCredential)
            }
            
        }
    }
}

//#Preview {
//
//    ContentView(authManager: AuthenticationManager(), appid: "123", apikey: "abc", userid: "onetwothree")
//}
