//
//  FaxDetailView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/9/24.
//

import SwiftUI
import SwiftData

struct FaxDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var localCredential: LocalCredential
    @ObservedObject var fax: Fax
    var dateTimeFormatter = DateTimeFormatter()
    
    @State private var isFaxPresented: Bool = false
    
    @Binding var status: ReplyStatus
    
    @ObservedObject var token: Token
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        
        return formatter
    }()
    
    var body: some View {
            Form {
                Section(header: Text("Fax Info"), footer: Text("Long Press to Copy Fax Info")) {
                    
                    Text("Date: \(dateTimeFormatter.formattedDateOnly(from: fax.completed_timestamp))")
                    
                    Text("Time: \(dateTimeFormatter.formattedTime(from: fax.completed_timestamp))")
                    
                    Text("Sender's FAX Number: \(fax.originating_fax_tsid)")
                    
                    Text("Number of Pages: \(String(fax.pages))")
                    Text("Image Downloaded: \(String(fax.image_downloaded))")
                    
                    Text("FAX ID: \(fax.fax_id)")

                }
                .contextMenu {
                    Button(action: copyFax) {
                        Text("Copy to clipboard")
                        Image(systemName: "doc.on.doc")
                    }
                }
                
                Section(header: Text("Action")) {

                    if status.replyStatusResult.rawValue == "No Status" {
                        Text("No Reply History")
                    } else {
                        Text("\(String(describing: status.replyStatusResult.rawValue)) by \(String(describing: status.replyMethod))")
                        Text("\(dateFormatter.string(from: status.replyTimeStamp))")
                    }
                    Button("Reply by FAX", systemImage: MenuIcon.replyByFax.rawValue) {
                        print("FAX button tapped")
                        isFaxPresented = true
                        print("token.access_token @Button Tapped, Reply by Fax, of FaxDetailView(): \(token.access_token)")
                        
                    }
                    .sheet(isPresented: $isFaxPresented) {
                        
                        FaxModalView(localCredential: localCredential, isFaxPresented: self.$isFaxPresented, fax: fax, status: $status, token: token)
                    }
                    
                    Button("Reply by Phone", systemImage: MenuIcon.replyByPhone.rawValue) {
                        
                    }
                    
                    Button("Reply by Message", systemImage: MenuIcon.replyByMessage.rawValue) {
                        
                    }
                    Button("Delete as Spam", systemImage: MenuIcon.deleteAsSpam.rawValue, action: {        
                        // Still display the fax data in Dashboard, but dim it as Archived
//                        status.replyMethod = .delete
//                        status.replyStatusResult = .deleted
                        update(replyMethod: .delete, replyStatusResult: .deleted)
                    })
                    
                    Button("No Action", systemImage: MenuIcon.noAction.rawValue, action: {
//                        status.replyMethod = .noAction
//                        status.replyStatusResult = .archived
                        update(replyMethod: .noAction, replyStatusResult: .archived)

                    })
                }
            .navigationTitle("FAX Details")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    private func update(replyMethod: ReplyMethodEnum, replyStatusResult: ReplyStatusResultEnum) {
        if status.replyStatusResult.rawValue == "No Status" {
//            let newDataToAdd = ReplyStatus(fax_id: fax.fax_id, replyMethod: ReplyMethodEnum.fax, replyStatusResult:  ReplyStatusResultEnum(rawValue: ReplyStatusResultEnum.completed.rawValue) ?? .noStatus, replyFaxID: "TEST", replyTimeStamp: Date())
            let newDataToAdd = ReplyStatus(fax_id: fax.fax_id, replyMethod: replyMethod, replyStatusResult:  replyStatusResult, replyFaxID: "TEST123", replyTimeStamp: Date()) // Obtain replyFaxID from eFax Corporate API later.
            
            modelContext.insert(newDataToAdd)
        } else {
            // else { update the exisiting reply status data with new values.
            status.replyTimeStamp = Date()
            status.replyMethod = replyMethod
            status.replyStatusResult = replyStatusResult
            
        }
    }

    

    private func copyFax() {
        let faxInfo = """
            Date: \(dateTimeFormatter.formattedDateOnly(from: fax.completed_timestamp))
            Time: \(dateTimeFormatter.formattedTime(from: fax.completed_timestamp))
            Sender FAX: \(fax.originating_fax_tsid)
            Number of Pages: \(fax.pages)
            Image Downloaded?: \(fax.image_downloaded)
            FAX ID: \(fax.fax_id)
            """
        
        UIPasteboard.general.string = faxInfo
    }

}

#Preview {
    let newDataToAdd = ReplyStatus(fax_id: "fax_id123", replyMethod: ReplyMethodEnum.fax, replyStatusResult:  ReplyStatusResultEnum(rawValue: ReplyStatusResultEnum.completed.rawValue) ?? .noStatus, replyFaxID: "TEST", replyTimeStamp: Date())

    @State var status = newDataToAdd
    let localCredential = LocalCredential(email: "asdfas", password: "asfaf", appid: "asfasf", apikey: "asfasf", userid: "asfasf", faxNumber: "asdfasf")
    
    let token = Token(access_token: "dummy access_token", token_type: "dummy token_type", expires_in: Date(), scope: "dummy scope", jti: "dummy jti")

    return FaxDetailView(localCredential: localCredential, fax: DemoData().demoFaxes.first!, status: $status, token: token)
}

