//
//  Token.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/30/24.
//

import Foundation

struct Token: Codable {
    var access_token: String
    var token_type: String
    var expires_in: Date
    var scope: String
    var jti: String
}
