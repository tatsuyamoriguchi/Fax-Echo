//
//  Token.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/30/24.
//

import Foundation

class Token: Codable, ObservableObject {
    var access_token: String
    var token_type: String
    var expires_in: Date
    var scope: String
    var jti: String
    
    init(access_token: String, token_type: String, expires_in: Date, scope: String, jti: String) {
        self.access_token = access_token
        self.token_type = token_type
        self.expires_in = expires_in
        self.scope = scope
        self.jti = jti
    }
}
