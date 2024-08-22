//
//  SendFaxResponse.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/15/24.
//

import Foundation


struct SendFaxResponse: Codable {
    let fax_id: String
    let destination_fax_number: String
}

struct SendFaxReponseError: Codable {
    let errors: [Errors]
    let transaction_id: String
}

struct Errors: Codable {
    let element_name: String
    let user_message: String
    let developer_message: String
    let more_info: String
    let error_code: String
}
