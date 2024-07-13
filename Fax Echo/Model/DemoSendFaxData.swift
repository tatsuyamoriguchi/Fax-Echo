//
//  DemoSendFaxData.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/12/24.
//

import Foundation

struct DemoSendFaxData {
    
    private let appid: String
    private let apikey: String
    
    let auth: String
    let authBase64: String
    let userid: String
    let headers: [String: String]
    let parameters: [String: Any]

    init(appid: String, apikey: String, userid: String) {
        
        self.appid = appid
        self.apikey = apikey
        self.auth = appid + ":" + apikey
        self.authBase64 = self.auth.toBase64()
        self.userid = userid
        
        self.headers = [
            "user-id": userid,
            "Authorization": "Basic " + authBase64,
            "transaction-id": "",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        self.parameters = [
            "destinations": [
                [
                    "to_name": "Joe Bloggs",
                    "to_company": "Acme Widgets Inc.",
                    "fax_number": "18665559999"
                ],
                [
                    "to_name": "Amy Winehouse",
                    "to_company": "Acme Widgets Inc.",
                    "fax_number": "18555444333"
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
                "client_code": "Sampel client_code",
                "client_id": "Sample client_id",
                "client_matter": "Sample client_matter",
                "client_name": "Sample client_name",
                "client_reference_id": "Sample client_reference_id",
                "billing_code": "Sample billing_coden"
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
        ]
    }
}
