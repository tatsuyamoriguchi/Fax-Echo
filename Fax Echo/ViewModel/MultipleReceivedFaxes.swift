//
//  MultipleReceivedFaxes.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/19/24.
//

import Foundation


class MultipleReceivedFaxes: ObservableObject {
    
    var authManager = AuthenticationManager()
    
//    var headers: [String: String] = [:]
    
    var request: NSMutableURLRequest?
    
    @Published var faxes: [Fax] = []
    
    func getFaxes(token: String, userid: String)    {
        
        // Initialize headers using authManager
        let headers = [
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
            "user-id": userid,
            "transaction-id": "",
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
        ]

 
        // Initialize the request with the URL and settings
        request = NSMutableURLRequest(url: NSURL(string: "https://api.securedocex.com/faxes/received")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
        
        // Set the HTTP method and headers
        request?.httpMethod = "GET"
        request?.allHTTPHeaderFields = headers
        
        // Perform the network request
        let session = URLSession.shared
        if let request = request {
            
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    print("Error fetching faxes from getFaxes(): \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse: \(httpResponse)")
                    if let data = data {
                        if let faxes = self.handleResponseData(data) {
                            DispatchQueue.main.async {
                                self.faxes = faxes
                                
                                print("")
                                print("Faxes updated from getFaxes(): \(faxes.count) faxes received")
                                self.printFaxes(faxes)

                            }
                            
                        }
                    }
                    
                }
                
            }
            dataTask.resume()
        }
    }
    
    private func handleResponseData(_ data: Data) -> [Fax]? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(MultipleReceivedFaxesResponse.self, from: data)
            return response.faxes
            
        } catch {
            print("Error decoding JSON at handleResponseData(): \(error.localizedDescription)")
            print("Error decoding JSON at handleResponseData(): \(error)")
            return nil
        }
    }
    
    
    private func printFaxes(_ faxes: [Fax]) {
        for fax in faxes {
            print("")
            print("faxes data from printFaxes()")
            print("completed_timestamp: \(fax.completed_timestamp)")
            print("fax_id: \(fax.fax_id)")
            print("fax_status: \(fax.fax_status)")
            print("image_downloaded: \(fax.image_downloaded)")
            print("originating_fax_number: \(fax.originating_fax_number)")
            print("originating_fax_tsid: \(fax.originating_fax_tsid)")
            print("pages: \(fax.pages)")
            
        }
        
        
    }
}



