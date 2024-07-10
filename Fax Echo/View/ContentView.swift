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
                
            } else {
                Login(authManager: authManager, localCredential: localCredential)
            }
            
        }
    }
}

#Preview {

    ContentView(authManager: AuthenticationManager(), localCredential: LocalCredential(email: "brasfaian@befasdfckos.com", password: "kakakak", appid: "1234", apikey: "abcd", userid: "OneTwoThree", faxNumber: "123-123-1234"))
}
