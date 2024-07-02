//
//  Item.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
