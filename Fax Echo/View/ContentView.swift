//
//  ContentView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var authManager = AuthenticationManager()
    
    var body: some View {
        
        Group {
            
            if authManager.isLoggedIn == true {
                HomeView(authManager: authManager)
            } else {
                Login(authManager: authManager)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
