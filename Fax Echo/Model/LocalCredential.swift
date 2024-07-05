//
//  LocalCredential.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/5/24.
//

import Foundation

class LocalCredential: ObservableObject {
    
    @Published var appid: String
    @Published var apikey: String
    @Published var userid: String
    
    init(appid: String, apikey: String, userid: String) {
        self.appid = appid
        self.apikey = apikey
        self.userid = userid
    }
    
}
