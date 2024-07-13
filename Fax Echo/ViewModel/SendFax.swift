//
//  SendFax.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/12/24.
//

import Foundation

class SendFax {

    func sendFax(appid: String, apikey: String, userid: String) {
        // Prepare postData
        let postData: Data
        do {
            postData = try JSONSerialization.data(withJSONObject: DemoSendFaxData(appid: appid, apikey: apikey, userid: userid) .parameters, options: [])
        } catch {
            // Handle the error as appropriate
            print("Error serializing JSON: \(error)")
            return // Exit the function if there's an error
        }

        // Prepare the request
        let url = URL(string: "https://api.securedocex.com/faxes")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"] // Example headers
        request.httpBody = postData

        // Create the session and data task
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                }
            }
        }

        // Start the data task
        dataTask.resume()
    }
}

