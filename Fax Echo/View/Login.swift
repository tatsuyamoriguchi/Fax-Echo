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

    @State var appid: String = ""
    @State var apikey: String = ""
    @State var userid: String = ""
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Fax Echo")
                .font(.custom("Inter-ExtraLight",size: 60))
            Text("ver 1.0")
                .font(.caption)
            Spacer()
            Image("fax-machine")
            Spacer()
            
            TextField("Enter your app-id", text: $appid)
                .textFieldStyle()
            TextField("Enter an api-key", text: $apikey)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                .scrollContentBackground(.hidden)
                .textFieldStyle()

            TextField("Enter your user-id", text: $userid)
                .focused($useridFieldIsFocused)
                .textFieldStyle()

            Spacer()
            
            HStack {
                Spacer()
                
                Button("Login") {
                    // Locally authenticate user's credentials first with appid and apikey.
                    print("appid entered: \(appid)")
                    do {
                        let apikeyRegistered = try Keychain().retrieveApikey(appid: appid)
                        if apikeyRegistered == apikey {
                            authManager.isLoggedIn = true
                            presentationMode.wrappedValue.dismiss()

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
        .background(Color.mint)
        
    }
}

#Preview {
    
    Login(authManager: AuthenticationManager())
}
