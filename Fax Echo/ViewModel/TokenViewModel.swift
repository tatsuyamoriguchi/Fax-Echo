//
//  TokenViewModel.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/30/24.
//

import Foundation

class TokenViewModel: ObservableObject {
    
    @Published var token: Token?

    func decodeJSON(jsonData: Data) {
        
//        guard let jsonData = jsonString.data(using: .utf8) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodeToken = try decoder.decode(Token.self, from: jsonData)
            self.token = decodeToken
            print("access_token: \(String(describing: self.token?.access_token))")
            
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
        
    }
}
