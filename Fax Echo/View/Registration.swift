//
//  Registration.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/13/24.
//

import SwiftUI

struct Registration: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var appid: String = ""
    @State private var apikey: String = ""
    @State private var userid: String = ""
    @State private var faxNumber: String = ""
    
    @State private var message = "Obtain your APP ID, API KEY, USER ID, FAX NUMBER from your Fax service admninistrator and enter them below"
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var useridFieldIsFocused: Bool
    @State private var authManager = AuthenticationManager()
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.leading)
                .frame(minWidth: 350)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding()

            TextField("eMail", text: $email)
                .textFieldStyle()
            TextField("Password", text: $password)
                .textFieldStyle()
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
                    registrationAction(emailGiven: email, passwordGiven: password, appidGiven: appid, apikeyGiven: apikey, useridGiven: userid, faxNumberGiven: faxNumber)
                    
                }
            }
            .foregroundStyle(Color("Button Color"))
        }
        .padding()
        .background(Color.mint)
        .presentationDetents([.medium])
        
    }

}

extension Registration {
    
    func registrationAction(emailGiven: String, passwordGiven: String, appidGiven: String, apikeyGiven: String, useridGiven: String, faxNumberGiven: String) {
        
        let isValid = authManager.register(email: emailGiven, password: passwordGiven, appid: appidGiven, apikey: apikeyGiven, userid: useridGiven, faxNumber: faxNumberGiven)
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
