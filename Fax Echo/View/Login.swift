//
//  Login.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/23/24.
//

import SwiftUI

struct Login: View {
    @FocusState private var useridFieldIsFocused: Bool
    
    @ObservedObject var authManager: AuthenticationManager
    
    @State private var showRegistration = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var localCredential: LocalCredential
    
    var body: some View {
        NavigationView {
            
            VStack {
                Spacer()
                Text("Fax Echo")
                    .font(.custom("Inter-ExtraLight",size: 60))
                Text("ver 1.0")
                    .font(.caption)
                Spacer()
                Image("fax-machine")
                Spacer()
                
                TextField("Enter your app-id", text: $localCredential.appid)
                    .textFieldStyle()
                    .onSubmit {
                        if !localCredential.appid.isEmpty {
                            authManager.appid = localCredential.appid
                            print("localCredential.appid: \(localCredential.appid)")
                            print("authManager.appid @Login: \(authManager.appid)")
                        }
                    }
                TextField("Enter an api-key", text: $localCredential.apikey)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .scrollContentBackground(.hidden)
                    .textFieldStyle()
                
                TextField("Enter your user-id", text: $localCredential.userid)
                    .focused($useridFieldIsFocused)
                    .textFieldStyle()
                
                Spacer()
                
                NavigationLink(
                    destination: ContentView(authManager: authManager, localCredential: localCredential)
                ) {
                        
                        HStack {
                            Spacer()
                            
                            Button("Login") {
                                // Locally authenticate user's credentials first with appid and apikey.
                                
                                do {
                                    let apikeyRegistered = try Keychain().retrieveApikey(appid: localCredential.appid)
                                    print("appid entered: \(localCredential.appid)")
                                    if apikeyRegistered == localCredential.apikey {
                                        authManager.isLoggedIn = true
                                        //                                        presentationMode.wrappedValue.dismiss()
                                        
                                    } else {
                                        print("apikey unmatched")
                                    }
                                    
                                } catch {
                                    print("apikeyRegistered unable to obtained.")
                                }
                                
                            }
                            .foregroundStyle(Color("Button Color"))
                            
                            Spacer()
                            
                            Button("Register") {
                                showRegistration.toggle()
                            }
                            .foregroundStyle(Color("Button Color"))
                            .sheet(isPresented: $showRegistration) {
                                Registration()
                            }
                            
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                    }
            }
            .background(Color.mint)
            
        }
    }
}

#Preview {
    
    Login(authManager: AuthenticationManager(), localCredential: LocalCredential(appid: "123", apikey: "abc", userid: "OneTwoThree"))
}
