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
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Provide a single shared SwiftData container for the whole app
                .modelContainer(for: [Pet.self, Activity.self, Expense.self, Budget.self])
        }
    }
}
