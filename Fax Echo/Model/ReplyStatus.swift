//
//  ReplyStatus.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/16/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ReplyStatus: Hashable {
    
    var fax_id: String
    var replyMethod: ReplyMethodEnum
    var replyStatusResult: ReplyStatusResultEnum
    var replyFaxID: String
    var replyTimeStamp: Date? = nil
    
    init(fax_id: String, replyMethod: ReplyMethodEnum, replyStatusResult: ReplyStatusResultEnum, replyFaxID: String, replyTimeStamp: Date) {
        self.fax_id = fax_id
        self.replyMethod = replyMethod
        self.replyStatusResult = replyStatusResult
        self.replyFaxID = replyFaxID
        self.replyTimeStamp = replyTimeStamp
    }
}

enum ReplyStatusResultEnum: String, Codable {
    case completed = "Replied"
    case failed = "Reply Failed"
    case noStatus = "No Status"
    case deleted = "Deleted"
    case archived = "Archived"
}

enum ReplyMethodEnum: String, Codable {
    case fax = "faxmachine.fill"
    case phone = "phone.fill.badge.checkmark"
    case message = "checkmark.message.fill"
    case email = "envelope.fill"
    case delete = "trash.fill"
    case noAction = "archivebox.fill"
    case noReply = "ellipsis" // "nosign"
}
