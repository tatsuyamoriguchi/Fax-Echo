//
//  Settings.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/15/24.
//
import SwiftUI

struct Settings: View {
    @ObservedObject var swipeSettings = SwipeSettings()
    
    var body: some View {
        Form {
            Section("FAX List Swipe Menu") {
                Toggle(isOn: $swipeSettings.isFaxReplyChecked) {
                    HStack {
                        Image(systemName: MenuIcon.replyByFax.rawValue)
                        Text("Reply by FAX")
                    }
                }
                .toggleStyle(SwitchToggleStyle())
 
                Toggle(isOn: $swipeSettings.isPhoneReplyChecked) {
                    HStack {
                        Image(systemName: MenuIcon.replyByPhone.rawValue)
                        Text("Reply by Phone")
                    }
                }
                .toggleStyle(SwitchToggleStyle())
                
                Toggle(isOn: $swipeSettings.isMessageReplyChecked) {
                    HStack {
                        Image(systemName: MenuIcon.replyByMessage.rawValue)
                        Text("Reply by Text Message")
                    }
                }
                .toggleStyle(SwitchToggleStyle())
                
                Toggle(isOn: $swipeSettings.isSpamChecked) {
                    HStack {
                        Image(systemName: MenuIcon.deleteAsSpam.rawValue)
                        Text("Delete as Spam")
                    }
                }
                .toggleStyle(SwitchToggleStyle())
                
                Toggle(isOn: $swipeSettings.isNoActionChecked) {
                    HStack {
                        Image(systemName: MenuIcon.noAction.rawValue)
                        Text("No Action")
                    }
                }
                .toggleStyle(SwitchToggleStyle())
            }
        }
    }
}

#Preview {
    Settings()
}
