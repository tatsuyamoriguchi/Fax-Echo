//
//  Registration.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/13/24.
//

import SwiftUI

struct Registration: View {
    @State private var appid: String = ""
    @State private var apikey: String = ""
    @State private var userid: String = ""
    @State private var faxNumber: String = ""

    @State private var message = "Obtain your APP ID, API KEY, and USER ID from your Fax Corporate Admninistrator and enter them below"
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var useridFieldIsFocused: Bool
    @State private var authManager = AuthenticationManager()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer(minLength: 50)
                Text(message)
                Spacer(minLength: 50)
                
            }
            Spacer()
            TextField("APP ID", text: $appid)
                .textFieldStyle()
            TextField("API KEY", text: $apikey)
                .textFieldStyle()
            TextField("USER ID", text: $userid)
                .textFieldStyle()
            TextField("FAX Number", text: $faxNumber)
                .textFieldStyle()
            Button("Register") {
                print("Register Tapped")
                if Keychain.doesAnyUserExist() == true {
                    message = "A user already exists. Only one user per a device is allowed."
                    appid = ""
                    apikey = ""
                    userid = ""
                    faxNumber = ""
                    
                    
                } else {
                    // Perform registration action
                    registrationAction(appidGiven: appid, apikeyGiven: apikey, useridGiven: userid, faxNumberGiven: faxNumber)
                    
                }
            }
            Spacer()
            Spacer()
        }
        .presentationDetents([.medium])
        
    }
}

extension Registration {
    
    func registrationAction(appidGiven: String, apikeyGiven: String, useridGiven: String, faxNumberGiven: String) {
        
        let isValid = authManager.register(appid: appidGiven, apikey: apikeyGiven, userid: useridGiven, faxNumber: faxNumberGiven)
        print(isValid)
        
        if isValid == true {
            print("registration completed")
            presentationMode.wrappedValue.dismiss()
            
        } else {
            message = "Unable to register. That user account already exists."
            appid = ""
            apikey = ""
            userid = ""
            faxNumber = ""
        }
        
        
    }
}


#Preview {
    Registration()
}
