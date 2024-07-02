//
//  Dashboard2.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/19/24.
//
// Debugging purpose only

import SwiftUI
import SwiftData

struct Dashboard2: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var replyStatuses: [ReplyStatus]

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(replyStatuses) { reply in
                    NavigationLink(value: reply) {
                        VStack(alignment: .leading) {
                            Text(reply.fax_id)
                            Text("\(reply.replyTimeStamp)")
                            Text(reply.replyStatusResult.rawValue)
                            
                        }
                    }
                }
            }
            .navigationTitle("FAX Recieved")
            .toolbar {
                Button("Add Data", action: addSamples)
            }

        }
    }
    
    private func addSamples() {
        let fax1 = ReplyStatus(fax_id: "1234", replyMethod: ReplyMethodEnum.fax, replyStatusResult: ReplyStatusResultEnum.completed, replyFaxID: "asdfjg12312", replyTimeStamp: Date())
        modelContext.insert(fax1)
    }
}

#Preview {
    Dashboard2()
        .modelContainer(for: ReplyStatus.self, inMemory: true)
}
