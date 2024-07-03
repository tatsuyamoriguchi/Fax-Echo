//
//  Dashboard3.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 7/3/24.
//

import SwiftUI
import SwiftData

struct FaxSectionView3: View {
    let date: String
    let faxes: [Fax]
    let replyStatuses: [ReplyStatus]
    let dateTimeFormatter: DateTimeFormatter
    let getReplyStatus: (String) -> ReplyStatus
    
    var body: some View {
        Section(header: Text(date)) {
            ForEach(faxes, id: \.fax_id) { fax in
                let currentStatus = replyStatuses.first { $0.fax_id == fax.fax_id }
                
                NavigationLink(value: fax) {
                    FaxRowView(
                        fax: fax,
                        dateTimeFormatter: dateTimeFormatter,
                        getReplyStatus: getReplyStatus,
                        currentStatus: currentStatus
                    )
                }
            }
        }
    }
}

struct FaxRowView3: View {
    let fax: Fax
    let dateTimeFormatter: DateTimeFormatter
    let getReplyStatus: (String) -> ReplyStatus
    let currentStatus: ReplyStatus?
    
    var body: some View {
        VStack {
            HStack {
                Text(dateTimeFormatter.formattedTime(from: fax.completed_timestamp))
                    .font(.caption)
                Text(fax.originating_fax_tsid)
                Text("\(fax.pages) pg")
                    .font(.caption)
                Image(systemName: getReplyStatus(fax.fax_id).replyMethod.rawValue)
                
                if currentStatus?.replyTimeStamp != nil {
                    let timeString = dateTimeFormatter.date2String(from: getReplyStatus(fax.fax_id).replyTimeStamp)
                    Text(dateTimeFormatter.formattedTime(from: timeString))
                        .font(.caption)
                }
            }
        }
    }
}

struct Dashboard3: View {
    @ObservedObject var authManager: AuthenticationManager
    
    @StateObject var multipleReceivedFaxes = MultipleReceivedFaxes()
    var dateTimeFormatter = DateTimeFormatter()
    @StateObject var swipeSettings = SwipeSettings()
    
    // State variable to store the selected fax ID for querying ReplyStatus
    @State private var selectedFaxID: String = ""
    
    @Environment(\.modelContext) var modelContext
    @Query var replyStatuses: [ReplyStatus]
    
    var groupedFaxes: [String: [Fax]] {
        Dictionary(grouping: multipleReceivedFaxes.faxes, by: { fax in
            dateTimeFormatter.formattedDateOnly(from: fax.completed_timestamp)
        })
    }
    
    var myFaxNumber: String {
        do {
            let faxNumberRegistered = try Keychain().retrieveMyFaxNumber(appid: authManager.appid)
            return faxNumberRegistered ?? "No Fax Number Registered"
        } catch {
            print("Unable to obtain myFaxNumber: \(error)")
            return "No Fax Number Registered"
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedFaxes.keys.sorted(), id: \.self) { date in
                    FaxSectionView(
                        date: date,
                        faxes: groupedFaxes[date]!,
                        replyStatuses: replyStatuses,
                        dateTimeFormatter: dateTimeFormatter,
                        getReplyStatus: getReplyStatus
                    )
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading)  {
                    Image("fax-machine")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: fetchFaxes) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                    }
                }
                ToolbarItem {
                    Text("\(myFaxNumber)")
                }
            }
            .onAppear {
                fetchFaxes()
            }
            .navigationDestination(for: Fax.self) { fax in
                FaxDetailView(fax: fax, status: Binding(
                    get: { getReplyStatus(for: fax.fax_id)  },
                    set: { _ in }
                ))
            }
        }
    }
    
    @ViewBuilder
    func SwipeMenuActions() -> some View {
        if swipeSettings.isNoActionChecked {
            Button {
                print("No Action")
            } label: {
                Label(noActionMenu.menuTitle.rawValue, systemImage: noActionMenu.icon.rawValue)
            }
        }
        
        if swipeSettings.isSpamChecked {
            Button {
                print("Delete as Spam")
            } label: {
                Label(spamMenu.menuTitle.rawValue, systemImage: spamMenu.icon.rawValue)
            }
        }
        
        if swipeSettings.isMessageReplyChecked {
            Button {
                print("Reply by Message")
            } label: {
                Label(messageMenu.menuTitle.rawValue, systemImage: messageMenu.icon.rawValue)
            }
        }
        
        if swipeSettings.isPhoneReplyChecked {
            Button {
                print("Reply by Phone")
            } label: {
                Label(phoneMenu.menuTitle.rawValue, systemImage: phoneMenu.icon.rawValue)
            }
        }
        
        if swipeSettings.isFaxReplyChecked {
            Button {
                print("Fax Sent")
            } label: {
                Label(faxMenu.menuTitle.rawValue, systemImage: faxMenu.icon.rawValue)
            }
        }
    }
    
    private func fetchFaxes() {
        authManager.getToken(appid: authManager.appid, apikey: authManager.apikey) { token in
            if let token = token {
                print("Token fetched from fetchFaxes(): \(token)")
                multipleReceivedFaxes.getFaxes(token: token, userid: authManager.userid)
            } else {
                print("Failed to fetch token at fetchFaxes()")
            }
        }
    }
    
    func getReplyStatus(for faxID: String) -> ReplyStatus {
        if let status = replyStatuses.first(where: { $0.fax_id == faxID }) {
            return status
        } else {
            return ReplyStatus(fax_id: "No Data", replyMethod: ReplyMethodEnum.noReply, replyStatusResult: ReplyStatusResultEnum.noStatus, replyFaxID: "No Data", replyTimeStamp: Date())
        }
    }
}

#Preview {
    Dashboard3(authManager: AuthenticationManager())
        .modelContainer(for: ReplyStatus.self, inMemory: true)
}

