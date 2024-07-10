//
//  FaxModalView.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/15/24.
//

import SwiftUI
import SwiftData

struct FaxModalView: View {
    @Binding var isFaxPresented: Bool
    @ObservedObject var fax: Fax
    @State private var test = ""
    @State private var saveAsTemplate = false
    @State private var messageSubject: String = ""
    @State private var messageBody: String = ""
    @State private var messageSignature: String = ""
    @Binding var status: ReplyStatus
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("FAX Destination") {
                        TextField("Destination FAX", text: $fax.originating_fax_number)
                        TextField("Destination Name", text: $fax.originating_fax_tsid)
                    }
                    
                    Section("Reply Message") {
                        HStack {
                            TextField("Your FAX numer", text: $fax.destination_fax_number)
                                .textFieldStyle()
                        }
                        HStack {
                            TextField("Enter Message Subject", text: $messageSubject)
                                .textFieldStyle()
                        }
                        HStack {
                            TextField("Enter Message Body", text: $messageBody)
                                .textFieldStyle()
                        }
                        HStack {
                            TextField("Your Message Signature", text: $messageSignature)
                                .textFieldStyle()
                        }
                        Toggle(isOn: $saveAsTemplate, label: {
                            Text("Save as Template")
                        })
                        
                        HStack {
                            Text("⚠️FAX transaction takes few minutes to complete. Please verify the status on Dashboard few minutes later.")
                                .font(.caption)
                        }
                    }
                }
                HStack {
                    Button("Dismiss") {
                        isFaxPresented = false
                    }
                    .padding()
                    Spacer()
                    Button(action: {
                        saveMessageDetails()
                        isFaxPresented = false
                        
                        // if reply status doesn't exists
                        if status.replyStatusResult.rawValue == "No Status" {
                            let newDataToAdd = ReplyStatus(fax_id: fax.fax_id, replyMethod: ReplyMethodEnum.fax, replyStatusResult:  ReplyStatusResultEnum(rawValue: ReplyStatusResultEnum.completed.rawValue) ?? .noStatus, replyFaxID: "TEST", replyTimeStamp: Date())
                            
                            modelContext.insert(newDataToAdd)
                        } else {
                            // else { update the exisiting reply status data with new values.
                            status.replyTimeStamp = Date()
                            status.replyMethod = .fax
                            status.replyStatusResult = .completed
//                            status.replyFaxID = ""
                            
                        }
                        
                    }) {
                        Text("Reply by Fax")
                    }
                    .padding()
                }
            }
            .navigationTitle("Reply by FAX")
            .navigationBarTitleDisplayMode(.automatic)
        }
        
        
        .onAppear {
            loadMessageDetails()
            
            // For Debug
            let demoData = DemoData()
            print(demoData.demoFaxes.first!.fax_id)
        }
    }
    
    private func saveMessageDetails() {
          UserDefaults.standard.set(messageSubject, forKey: "messageSubject")
          UserDefaults.standard.set(messageBody, forKey: "messageBody")
          UserDefaults.standard.set(messageSignature, forKey: "messageSignature")
      }
      
      private func loadMessageDetails() {
          if let savedMessageSubject = UserDefaults.standard.string(forKey: "messageSubject") {
              messageSubject = savedMessageSubject
          }
          if let savedMessageBody = UserDefaults.standard.string(forKey: "messageBody") {
              messageBody = savedMessageBody
          }
          if let savedMessageSignature = UserDefaults.standard.string(forKey: "messageSignature") {
              messageSignature = savedMessageSignature
          }
      }
    
}



#Preview {
    @State var isPresented = true
    let newDataToAdd = ReplyStatus(fax_id: "fax_id123", replyMethod: ReplyMethodEnum.fax, replyStatusResult:  ReplyStatusResultEnum(rawValue: ReplyStatusResultEnum.completed.rawValue) ?? .noStatus, replyFaxID: "TEST", replyTimeStamp: Date())

    @State var status = newDataToAdd
    
    return FaxModalView(isFaxPresented: $isPresented, fax: DemoData().demoFaxes.first!, status: $status)
}
