//
//  FaxDetailView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/9/24.
//

import SwiftUI
import SwiftData
import Contacts

struct FaxDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var localCredential: LocalCredential
    @ObservedObject var fax: Fax
    var dateTimeFormatter = DateTimeFormatter()
    
    @State private var isFaxPresented: Bool = false
    
    @Binding var status: ReplyStatus
    
    @ObservedObject var token: Token
    
    @State private var selectedContactIndex: Int = 0 // Tracks the selected contact index
    @State var contacts: [CNContact] = []
    var phoneNumbers: [CNPhoneNumber] = []
    
    
    let phoneCall = PhoneCall()
    
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
                
                
                VStack(alignment: .leading){
                    
//                    Label("Reply by Phone", systemImage: MenuIcon.replyByPhone.rawValue)
//                    // .lineLimit(3) // Ensure single line
//                        .fixedSize(horizontal: true, vertical: false) // Prevents text from wrapping
                    // Button to invoke the action
                    Button("Reply by Phone", systemImage: MenuIcon.replyByPhone.rawValue) {
                        callSelectedContact()
                    }

//                    Button(action: {
//                        callSelectedContact()
//                    }) {
//                        HStack {
//                            Image(systemName: MenuIcon.replyByPhone.rawValue)
//                        }
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                    }

                    
                    VStack {
                        // Display Contacts name, org name in the section header
                        // *If not found, display "No contact info found"
                        // Make Picker rows clickable to execute actions.
                        
                        if !contacts.isEmpty {
                            
                            Picker("", selection: $selectedContactIndex) { // Bind to selectedContactIndex
                                
                                ForEach(contacts.indices, id: \.self) { index in
                                                                        
                                    Text("\(contacts[index].givenName) \(contacts[index].familyName) - \(contacts[index].organizationName):  \(contacts[index].phoneNumbers.first?.value.stringValue ?? "No Phone Number Found")")
//                                    Text("\(contacts[index].organizationName)")  
                                        .tag(index) // Tag each row with its index
                                    //                                            .onTapGesture {
                                    //                                                //  Clickable telphone number
                                    //                                                Link("TEST", destination: URL(string: "tel:\(contacts[index].phoneNumbers.first?.value.stringValue ?? "No Phone Number Found")")!)
                                    //                                                print("Hello")
                                    //                                            }
                                    
                                }
                                
                            }
                            .pickerStyle(.menu)
                            
//                            Divider()
                            
                            // Display the selected row details
                            //                            VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                               
//                                    Text("\(contacts[selectedContactIndex].givenName) \(contacts[selectedContactIndex].familyName)")
//                                        .frame(maxWidth: .infinity, alignment: .leading) // Push name to the left
//                                    
//                                    Text("\(contacts[selectedContactIndex].phoneNumbers.first?.value.stringValue ?? "No Phone Number")")
                                    
//                                        .padding()
//                                        .background(Color.gray.opacity(0.1))
//                                        .cornerRadius(8)
//                                        .lineLimit(1) // Prevent text wrapping
//                                        .truncationMode(.tail) // Add ellipsis if text overflows
//                                        .frame(maxWidth: .infinity, alignment: .center) // Allow it to grow horizontally
                                    
                                
//                                // Button to invoke the action
//                                Button(action: {
//                                    callSelectedContact()
//                                }) {
//                                    HStack {
//                                        Image(systemName: "phone.fill")
//                                    }
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(8)
//                                }
//                            }
                            
//                            .padding()
                            
                            
                        } else {
                            Text("No contact info found")
                            
                        }
                        
                    }
                }
                
                Button("Reply by Message", systemImage: MenuIcon.replyByMessage.rawValue) {
                }
                Button("Delete as Spam", systemImage: MenuIcon.deleteAsSpam.rawValue, action: {
                    // Not actually deleted
                    // Update ReplyStatus data as deleted,
                    // Still display the fax data in Dashboard, but dim it as Archived
                    update(replyMethod: .delete, replyStatusResult: .deleted)
                })
                
                Button("No Action", systemImage: MenuIcon.noAction.rawValue, action: {
                    update(replyMethod: .noAction, replyStatusResult: .archived)
                    
                })
            }
            .navigationTitle("FAX Details")
            .navigationBarTitleDisplayMode(.automatic)
            // Use `.task` to run the async function when the view appears
            .task {
                contacts = await phoneCall.fetchSpecificContact(fax: fax)
            }
        }
        
    }
    
    
    private func callSelectedContact() {
        //        if let phoneNumber = contacts[index].phoneNumbers.first?.value.stringValue {
        //            if let url = URL(string: "tel: \(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
        //                UIApplication.shared.canOpenURL(url)
        //            }
        //        }
        //        print("Tapped contact at \(index). ")
        //
        let contact = contacts[selectedContactIndex]
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue,
           let url = URL(string: "tel:\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        print("Calling \(contact.givenName) \(contact.familyName)")
        
    }
    
    private func update(replyMethod: ReplyMethodEnum, replyStatusResult: ReplyStatusResultEnum) {
        if status.replyStatusResult.rawValue == "No Status" {
            // ReplyStatus data is not created yet when a received fax data is detected for the first time.
            // So you need to create a new ReplyStatus data when trying to modify it for the first time.
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

