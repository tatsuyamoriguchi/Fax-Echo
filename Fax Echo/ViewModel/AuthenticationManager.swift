//
//  AuthenticationManager.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/23/24.
//

import Foundation
import Security

class AuthenticationManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published private var access_token: String = ""

    // Aren't these supposed to be Model?
    @Published var appid: String = ""
    @Published var apikey: String = ""
    @Published var userid: String = ""
        
    
    func register(email: String, password: String, appid: String, apikey: String, userid: String, faxNumber: String) -> Bool {
        
        do {
            let userCredentials = UserCredentials(email: email, password: password, appid: appid, apikey: apikey, userid: userid, faxNumber: faxNumber)
            try Keychain.saveUserCredentials(userCredentials)
            
//            try Keychain.save(email: email, password: password, appid: appid, apikey: apikey, userid: userid, faxNumber: faxNumber)
            self.isLoggedIn = true
            print("User registered with email: \(email), password: \(password), appid: \(appid), apikey: \(apikey), userid: \(userid), and faxNumber: \(faxNumber)")
        } catch {
            self.isLoggedIn = false
            print("Error saving user credentials: \(error.localizedDescription)")
        }
        return self.isLoggedIn
        
    }

    
    func getToken(appid: String, apikey: String, completion: @escaping (String?) -> Void) {
        let auth: String = appid + ":" + apikey
        let authBase64 = auth.toBase64()

        let headers = [
          "transaction-id": "",
          "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
          "Accept": "application/json",
          // Encode appid:appkey in Base64
          "Authorization": "Basic " + authBase64
        ]

        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.securedocex.com/tokens")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error)  in
            if let error = error {
              // Display a pop up sheet to a user that somthing wrong with session.dataTask, contact your Fax Corporate Admninistrator.
              // Invoke userid to send to registered Fax Corporate Administrator
                print("Error fetching access_token: \(error)")
                completion(nil)
          } else {
              let jsonDecoder = JSONDecoder()
              
              if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let tokenDictionary = try? jsonDecoder.decode(Token.self, from: data!) {

                  DispatchQueue.main.async {
                      self.access_token = tokenDictionary.access_token
                      print("Token received from getToken(): \(self.access_token)")
                      completion(self.access_token)
                  }

              } else {
                  // Display a pop up sheet to a user that somthing wrong with your bearer token, and contact your Fax Corporate Admninistrator.
                  // Invoke userid to send to registered Fax Corporate Administrator
                  print("Error from getToken(): \(String(describing: error?.localizedDescription))")
                  completion(nil)
              }
              
          }
        }

        dataTask.resume()
    }
    
    func logout() {
        
    }
}
