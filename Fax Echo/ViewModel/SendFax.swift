//
//  SendFax.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/12/24.
//

import Foundation

class SendFax {
    
    private let baseURL = "https://api.securedocex.com/faxes"
    
    func sendFax4(authToken: String, userid: String) async {
        
        let headers = [
            "user-id": userid,
            "Authorization": "Bearer " + authToken,
            "transaction-id": "",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let parameters = [
            "destinations": [
                [
                    "to_name": "Joe Bloggs",
                    "to_company": "Acme Widgets Inc.",
                    "fax_number": "81342167158"
                ]
            ],
            "fax_options": [
                "image_resolution": "STANDARD",
                "include_cover_page": true,
                "cover_page_options": [
                    "from_name": "Mary Adams",
                    "subject": "Endorsement",
                    "message": "Excepteur sint occaecat cupidatat non proident"
                ],
                "retry_options": [
                    "non_billable": 2,
                    "billable": 3,
                    "human_answer": 1
                ]
            ],
            "client_data": [
                "client_code": "aliquip sit proident",
                "client_id": "occaecat tempor",
                "client_matter": "ut occaecat qui est aliquip",
                "client_name": "nisi consectetur",
                "client_reference_id": "minim ex in",
                "billing_code": "eu occaecat aliquip in"
            ],
            "documents": [
                [
                    "document_type": "TXT",
                    "document_content": "VGhpcyBpcyBhIHRlc3QuIFRlc3QgMS4="
                ],
                [
                    "document_type": "TXT",
                    "document_content": "VGhpcyBpcyBhIHRlc3QuIFRlc3QgMi4="
                ]
            ]
        ] as [String : Any]
        
        let postData: Data
        
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        var request = URLRequest(url: URL(string: "https://api.securedocex.com/faxes")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 400 {
                print("400 error found")
                do {
                    let errorResponse = try JSONDecoder().decode(SendFaxReponseError.self, from: data)
                    print("Error Response: \(errorResponse)")
                } catch {
                    print("Error decoding JSON response: \(error)")
                }
            } else {
                print("Response Status Code: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    
    
    // Async/Await version function to send a fax
    func sendFax3(authToken: String, userid: String) async throws -> SendFaxResponse {
        //Async/Await
        // Step 1: Validate the base URL string
        // if baseURL is not a valid URL:
        // throw an error indicating a bad URL
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        // Step 2: Create a URL request object
        // create a URLRequest object with the URL
        var request = URLRequest(url: url)
        
        // Step 3: Set the HTTP method to POST
        // set the HTTP method of the request to POST
        request.httpMethod = "POST"
        
        // Step 4: Add necessary headers to the request
        // add an "Authorization" header with the value "Bearer YOUR_API_TOKEN"
        request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        // add a "Content-Type" header with the value "application/json"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "transaction-id")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Step 5: Prepare the request body(parameters)
        // create a dictionary (or map) for the request body containing:
        let body = [
            "destinations": [
                [
                    "to_name": "Joe Bloggs",
                    "to_company": "Acme Widgets Inc.",
                    "fax_number": "81342167158"
                ]
            ],
            "fax_options": [
                "image_resolution": "STANDARD",
                "include_cover_page": true,
                "cover_page_options": [
                    "from_name": "Mary Adams",
                    "subject": "Endorsement",
                    "message": "Excepteur sint occaecat cupidatat non proident"
                ],
                "retry_options": [
                    "non_billable": 2,
                    "billable": 3,
                    "human_answer": 1
                ]
            ],
            "client_data": [
                "client_code": "aliquip sit proident",
                "client_id": "occaecat tempor",
                "client_matter": "ut occaecat qui est aliquip",
                "client_name": "nisi consectetur",
                "client_reference_id": "minim ex in",
                "billing_code": "eu occaecat aliquip in"
            ],
            "documents": [
                [
                    "document_type": "TXT",
                    "document_content": "VGhpcyBpcyBhIHRlc3QuIFRlc3QgMS4="
                ],
                [
                    "document_type": "TXT",
                    "document_content": "VGhpcyBpcyBhIHRlc3QuIFRlc3QgMi4="
                ]
            ]
        ] as [String : Any]
        
        
        // Step 6: Convert the request body to JSON format
        // convert the dictionary (or map) to JSON data
        // set this JSON data as the HTTP body of the request
        //        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        do {
            let postData = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            // Handle the error as appropriate
            print("Error serializing JSON: \(error)")
            return  SendFaxResponse.init(fax_id: "ERROR", destination_fax_number: "ERROR")// Exit the function if there's an error
        }
        
        
        // Step 7: Perform the network request asynchronously
        // execute the network request using URLSession, waiting for the response
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Step 8: Decode the response data into a SendFaxResponse object
        // decode the received data into a SendFaxResponse object
        // Step 9: Return the decoded SendFaxResponse object
        // return the SendFaxResponse object
        return try JSONDecoder().decode(SendFaxResponse.self, from: data)
        
    }
    
    
    
    func sendFax2(authToken: String, userid: String) {
        
        let headers = [
            "user-id": userid,
            "Authorization": "Bearer " + authToken,
            "transaction-id": "",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // The following property values are dummy values to send a fax.
        let parameters = [
            "destinations": [
                [
                    "to_name": "Joe Bloggs",
                    "to_company": "Acme Widgets Inc.",
                    "fax_number": "81342167158"
                ]
            ],
            "fax_options": [
                "image_resolution": "STANDARD",
                "include_cover_page": true,
                "cover_page_options": [
                    "from_name": "Mary Adams",
                    "subject": "Endorsement",
                    "message": "Excepteur sint occaecat cupidatat non proident"
                ],
                "retry_options": [
                    "non_billable": 2,
                    "billable": 3,
                    "human_answer": 1
                ]
            ],
            "client_data": [
                "client_code": "aliquip sit proident",
                "client_id": "occaecat tempor",
                "client_matter": "ut occaecat qui est aliquip",
                "client_name": "nisi consectetur",
                "client_reference_id": "minim ex in",
                "billing_code": "eu occaecat aliquip in"
            ],
            "documents": [
                [
                    "document_type": "TXT",
                    "document_content": "VGhpcyBpcyBhIHRlc3QuIFRlc3QgMS4="
                ],
                [
                    "document_type": "TXT",
                    "document_content": "VGhpcyBpcyBhIHRlc3QuIFRlc3QgMi4="
                ]
            ]
        ] as [String : Any]
        
        let postData: Data
        
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // Handle the error as appropriate
            print("Error serializing JSON: \(error)")
            return // Exit the function if there's an error
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.securedocex.com/faxes")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 400 {
                print("400 error found")
                
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(SendFaxReponseError.self, from: data)
                        print("Error Response: \(errorResponse)")
                    } catch {
                        print("Error decoding JSON response: \(error)")
                        
                    }
                } else {
                    print("No data received for 400 error")
                }
            } else {
                print("Response Status Code: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
            }
        })
        
        dataTask.resume()
    }
    
    
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
                print("You got an error: \(error)")
                print()
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("You got a reponse: \(httpResponse)")
                }
            }
        }
        
        // Start the data task
        dataTask.resume()
    }
}

