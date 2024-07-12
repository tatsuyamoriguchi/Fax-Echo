//
//  DemoSendFaxData.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/12/24.
//

import Foundation

struct DemoSendFaxData {
    let headers = [
        "user-id": "",
        "Authorization": "",
        "transaction-id": "",
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    let parameters = [
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
    
    
}
