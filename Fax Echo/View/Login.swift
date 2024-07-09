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
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                Spacer()
                Text("Fax Echo")
                    .font(.custom("Inter-Thin",size: 60))
                Text("ver 1.0")
                    .font(.caption)
                Spacer()
                Image("fax-machine")
                Spacer()

                TextField("Enter your email", text: $email)
                    .textFieldStyle()
//                    .onSubmit {
//                        if !email.isEmpty && localCredential.email == email {
//
//                            authManager.appid = localCredential.appid
//                            print("localCredential.email: \(localCredential.email)")
//                            print("authManager.appid @Login: \(authManager.appid)")
//                        }
//                    }
                
                TextField("Enter your password", text: $password)
                    .textFieldStyle()
//                    .onSubmit {
//                        if !password.isEmpty && localCredential.password == password {
//                            authManager.apikey = localCredential.apikey
//                            print("localCredential.password: \(localCredential.password)")
//                            print("authManager.apikey @Login: \(authManager.apikey)")
//                        }
//                    }
                // What about userid??


//                TextField("Enter your app-id", text: $localCredential.appid)
//                    .textFieldStyle()
//                    .onSubmit {
//                        if !localCredential.appid.isEmpty {
//                            authManager.appid = localCredential.appid
//                            print("localCredential.appid: \(localCredential.appid)")
//                            print("authManager.appid @Login: \(authManager.appid)")
//                        }
//                    }
//                TextField("Enter an api-key", text: $localCredential.apikey)
//                    .autocorrectionDisabled(true)
//                    .autocapitalization(.none)
//                    .scrollContentBackground(.hidden)
//                    .textFieldStyle()
//                    .onSubmit {
//                        if !localCredential.apikey.isEmpty {
//                            authManager.apikey = localCredential.apikey
//                            print("localCredential.apikey: \(localCredential.apikey)")
//                            print("authManager.apikey @Login: \(authManager.apikey)")
//                        }
//                    }
//                
//                TextField("Enter your user-id", text: $localCredential.userid)
//                    .focused($useridFieldIsFocused)
//                    .textFieldStyle()
//                    .onSubmit() {
//                        if !localCredential.userid.isEmpty {
//                            authManager.userid = localCredential.userid
//                            print("localCredential.userid: \(localCredential.userid)")
//                            print("authManager.userid @Login: \(authManager.userid)")
// 
//                        }
//                    }
                
                Spacer()
                
                NavigationLink(
                    destination: ContentView(authManager: authManager, localCredential: localCredential)
                ) {
                        
                        HStack {
                            Spacer()
                            
                            Button("Login") {
                                // check if all credential info are input
                                if !email.isEmpty && !password.isEmpty && localCredential.email == email && localCredential.password == password {
                                    //                            authManager.appid = localCredential.appid
                                } else {
                                    print("The credential input doesn't match with the registered record.")
                                }

                                    
                                // Locally authenticate user's credentials first with appid and apikey.
                                do {
                                    
                                    // let retrievedCredentials = try retrieveUserCredentials(email: email)
                                    // print(retrievedCredentials)
//                                    let apikeyRegistered = try Keychain().retrieveUserCredentials(appid: localCredential.appid)

                                    // what about appid to pass? -> As long as email and password are matched,
                                    // appid, apikey, and userid are fine. Pass them to localCredential
                                    let apikeyRegistered = try Keychain().retrieveApikey(appid: localCredential.appid)
                                    
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
                    }
            }
            .background(Color.mint)
        }
    }
}

#Preview {
    
    Login(authManager: AuthenticationManager(), localCredential: LocalCredential(email: "", password: "", appid: "", apikey: "", userid: ""))
}
