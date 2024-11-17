//
//  SwipeMenu.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/12/24.
//

import Foundation

struct SwipeMenu {
    let menuType: MenuType
    let menuTitle: MenuTitle
    let icon: MenuIcon
    
}

let faxMenu = SwipeMenu(menuType: .isFaxReplyChecked, menuTitle: .replyByFax, icon: .replyByFax)
let phoneMenu = SwipeMenu(menuType: .isPhoneReplyChecked, menuTitle: .replyByPhone, icon: .replyByPhone)
let messageMenu = SwipeMenu(menuType: .isMessageReplyChecked, menuTitle: .replyByMessage, icon: .replyByMessage)
let spamMenu = SwipeMenu(menuType: .isSpamChecked, menuTitle: .deleteAsSpam, icon: .deleteAsSpam)
let noActionMenu = SwipeMenu(menuType: .isNoActionChecked, menuTitle: .noAction, icon: .noAction)



enum MenuType {
    
    case isFaxReplyChecked
    case isPhoneReplyChecked
    case isMessageReplyChecked
    case isSpamChecked
    case isNoActionChecked
}

enum MenuTitle: String {
    case replyByFax = "Reply by FAX"
    case replyByPhone = "Reply by Phone"
    case replyByMessage = "Reply by Message"
    case deleteAsSpam = "Delete as Spam"
    case noAction = "No Action"
}

enum MenuIcon: String {
    
    case replyByFax = "faxmachine.fill"
    case replyByPhone = "phone.bubble.fill"
    case replyByMessage = "text.bubble.fill"
    case deleteAsSpam = "trash.fill"
    case noAction = "archivebox.fill"
}

