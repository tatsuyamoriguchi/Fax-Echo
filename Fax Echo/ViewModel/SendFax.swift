//
//  SendFax.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/12/24.
//

import Foundation

class SendFax {
    let postData: Data
    let request: NSMutableURLRequest
    let session: URLSession
    let demoSendFaxData = DemoSendFaxData()

    init() {
        do {
            postData = try JSONSerialization.data(withJSONObject: demoSendFaxData.parameters, options: [])
            
        } catch {
            // Handle the error as appropriate
            print("Error serializing JSON: \(error)")
            postData = Data() // Assign an empty Data or handle it accordingly
        }
        
        
        
        request = NSMutableURLRequest(url: NSURL(string: "https://api.securedocex.com/faxes")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = demoSendFaxData.headers
        request.httpBody = postData as Data
        
        session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                }
            }
        })
        
        dataTask.resume()
    }
}

