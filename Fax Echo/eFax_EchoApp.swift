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
    @ObservedObject var authManager = AuthenticationManager()
    
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
                if authManager.isLoggedIn == true {
                    ContentView(authManager: authManager)
                        .modelContainer(sharedModelContainer)
                } else {
                    Login(authManager: authManager)
                        .modelContainer(sharedModelContainer)
                }
            }
        }
    }
}

