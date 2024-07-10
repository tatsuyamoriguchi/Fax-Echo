//
//  FaxDetailView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/9/24.
//

import SwiftUI
import SwiftData

struct FaxDetailView: View {
    // multipleReceivedFaxes is not necessary here???
    @StateObject var multipleReceivedFaxes = MultipleReceivedFaxes()
    
    @ObservedObject var fax: Fax
    var dateTimeFormatter = DateTimeFormatter()
    
    @State private var isFaxPresented: Bool = false
    
    @Binding var status: ReplyStatus
    
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

//                    if status.replyStatusResult.rawValue.isEmpty {
                    if status.replyStatusResult.rawValue == "No Status" {
                        Text("No Reply History")
                    } else {
                        Text("\(String(describing: status.replyStatusResult.rawValue)) by \(String(describing: status.replyMethod))")
                        Text("\(dateFormatter.string(from: status.replyTimeStamp))")
                    }
                    Button("Reply by FAX", systemImage: MenuIcon.replyByFax.rawValue) {
                        print("FAX button tapped")
                        isFaxPresented = true
                        
                    }
                    .sheet(isPresented: $isFaxPresented) {
                        
                        FaxModalView(isFaxPresented: self.$isFaxPresented, fax: fax, status: $status)
                    }
                    
                    Button("Reply by Phone", systemImage: MenuIcon.replyByPhone.rawValue) {
                        
                    }
                    
                    Button("Reply by Message", systemImage: MenuIcon.replyByMessage.rawValue) {
                        
                    }
                    Button("Delete as Spam", systemImage: MenuIcon.deleteAsSpam.rawValue) {
                        
                    }
                    Button("No Action", systemImage: MenuIcon.noAction.rawValue) {
                        
                    }
                }
            .navigationTitle("FAX Details")
            .navigationBarTitleDisplayMode(.automatic)
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

    return FaxDetailView(fax: DemoData().demoFaxes.first!, status: $status)
}

