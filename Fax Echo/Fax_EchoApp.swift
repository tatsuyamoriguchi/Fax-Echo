//
//  Fax_EchoApp.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/11/24.
//

import SwiftUI
import SwiftData

@main
struct Fax_EchoApp: App {
    
    @ObservedObject var localCredential = LocalCredential(email: "", password: "", appid: "", apikey: "", userid: "", faxNumber: "")
    @ObservedObject var authManager = AuthenticationManager()
    @ObservedObject var token = Token(access_token: "", token_type: "", expires_in: Date(), scope: "", jti: "")

    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ReplyStatus.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            Group {

                ContentView(authManager: authManager, localCredential: localCredential, token: token)
                        .modelContainer(sharedModelContainer)
            }
        }
    }
}

