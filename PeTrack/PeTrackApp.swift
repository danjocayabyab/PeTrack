//
//  PeTrackApp.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI
import SwiftData

@main
struct PeTrackApp: App {
    let container: ModelContainer
    
    init() {
        // Print database location for debugging
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            print("📁 Database location: \(url.path)")
        }
        
        do {
            // Create a new schema with all models
            let schema = Schema([
                Pet.self,
                Activity.self,
                Expense.self,
                Budget.self
            ])
            
            // Use persistent storage
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,  // This enables data persistence between launches
                allowsSave: true
            )
            
            // Create the container
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, container.mainContext)
        }
        .modelContainer(container)
    }
}
