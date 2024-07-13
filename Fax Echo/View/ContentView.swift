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
    @ObservedObject var token: Token

    
    var body: some View {
        
        Group {
            
            if authManager.isLoggedIn == true {
                HomeView(authManager: authManager, localCredential: localCredential, token: token)
                
                
            } else {
                Login(authManager: authManager, localCredential: localCredential, token: token)
            }
            
        }
    }
}

#Preview {
    
        let authManager = AuthenticationManager()
        let localCredential = LocalCredential(
            email: "brasfaian@befasdfckos.com",
            password: "kakakak",
            appid: "1234",
            apikey: "abcd",
            userid: "OneTwoThree",
            faxNumber: "123-123-1234"
        )
        let token = Token(
            access_token: "dummy access_token",
            token_type: "dummy token_type",
            expires_in: Date(),
            scope: "dummy scope",
            jti: "dummy jti"
        )
        
        return ContentView(authManager: authManager, localCredential: localCredential, token: token)
    //    let token = Token(access_token: "dummy access_token", token_type: "dummy token_type", expires_in: Date(), scope: "dummu scope", jti: "dummy jti")
//
//    return ContentView(authManager: AuthenticationManager(), localCredential: LocalCredential(email: "brasfaian@befasdfckos.com", password: "kakakak", appid: "1234", apikey: "abcd", userid: "OneTwoThree", faxNumber: "123-123-1234"), token: token)
}
