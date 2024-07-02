//
//  SwipeSettings.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/13/24.
//


import SwiftUI

class SwipeSettings: ObservableObject {
    @AppStorage("isFaxReplyChecked") var isFaxReplyChecked: Bool = true
    @AppStorage("isPhoneReplyChecked") var isPhoneReplyChecked: Bool = false
    @AppStorage("isMessageReplyChecked") var isMessageReplyChecked: Bool = false
    @AppStorage("isSpamChecked") var isSpamChecked: Bool = true
    @AppStorage("isNoActionChecked") var isNoActionChecked: Bool = true
}

