//
//  LocalCredential.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/5/24.
//

import Foundation

class LocalCredential: ObservableObject {
    
    @Published var email: String
    @Published var password: String
    @Published var appid: String
    @Published var apikey: String
    @Published var userid: String
    
    init(email: String, password: String, appid: String, apikey: String, userid: String) {
        self.email = email
        self.password = password
        self.appid = appid
        self.apikey = apikey
        self.userid = userid
    }
    
}
