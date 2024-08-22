//
//  SendFaxAPIServiceProtocol.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 8/12/24.
//

import Foundation

protocol SendFaxAPIServiceProtocol {
    func sendFax(  userId: String,
                   authorization: String,
                   transactionId: String,
                   destinations: [[String: Any]],
                   faxOptions: [String: Any],
                   clientData: [String: String],
                   documents: [[String: String]]
    ) async throws -> SendFaxResponse
    
}
