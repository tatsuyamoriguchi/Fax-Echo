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
    @ObservedObject var token: Token
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                Spacer()
                Text("Fax Echo")
                    .font(.custom("Inter-Light",size: 60))
                    .foregroundStyle(Color.white)
                
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
                
                Spacer()
                
                NavigationLink(
                    destination: ContentView(authManager: authManager, localCredential: localCredential, token: token)
                ) {
                        
                        HStack {
                            Spacer()
                            
                            Button("Login") {
                                // check if email or password is not empty
                                if !email.isEmpty && !password.isEmpty {

                                } else {
                                    print("The credential input doesn't match with the registered record.")
                                }

                                    
                                // Locally authenticate user's credentials first with appid and apikey.
                                do {
                                    
                                    // Retreive stored credentials with input email
                                    let retrievedCredentials = try Keychain.retrieveUserCredentials(email: email)
                                    
                                    // For debug
                                    print("-- Registered user credentials --")
                                    print(retrievedCredentials.email)
                                    print(retrievedCredentials.password)
                                    print(retrievedCredentials.appid)
                                    print(retrievedCredentials.apikey)
                                    print(retrievedCredentials.userid)
                                    print(retrievedCredentials.faxNumber)
                                    print("----")
                                    
                                                            
                                    if retrievedCredentials.email == email && retrievedCredentials.password == password {
                                        localCredential.email = retrievedCredentials.email
                                        localCredential.password = retrievedCredentials.password
                                        localCredential.appid = retrievedCredentials.appid
                                        localCredential.apikey = retrievedCredentials.apikey
                                        localCredential.userid = retrievedCredentials.userid
                                        localCredential.faxNumber = retrievedCredentials.faxNumber
                                        
                                        authManager.isLoggedIn = true
                                    } else {
                                        print("email or password unmatched")
                                    }
                                    
                                    
                                } catch {
                                    print("No such email, \(email) is found registered.")
                                }
                                
                            }
                            
                            .font(.custom("Inter-Light",size: 20))
                            .foregroundStyle(Color.white)
                            .background(Color.teal)
                            .cornerRadius(5)
//                            .border(.white)
                            
                            Spacer()
                            
                            Button("Register") {
                                showRegistration.toggle()
                            }
                            .font(.custom("Inter-Light",size: 20))
                            .foregroundStyle(Color.white)
                            .background(Color.teal)
                            .cornerRadius(5)
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
    let token = Token(access_token: "", token_type: "", expires_in: Date(), scope: "", jti: "")
    return Login(authManager: AuthenticationManager(), localCredential: LocalCredential(email: "", password: "", appid: "", apikey: "", userid: "", faxNumber: ""), token: token)
}
