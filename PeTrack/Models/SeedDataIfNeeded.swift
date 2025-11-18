//
//  SeedDataIfNeeded.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import Foundation
import SwiftData

enum SeedDataIfNeeded {
    static func run(in container: ModelContainer) throws {
        let context = ModelContext(container)

        // If we already have pets, assume seeded
        let petFetch = FetchDescriptor<Pet>(predicate: #Predicate { _ in true })
        if let count = try? context.fetch(petFetch).count, count > 0 { return }

        // Seed pets
        for p in Pet.mockPets { context.insert(p) }

        // Seed activities
        for a in Activity.mockScheduleActivities { context.insert(a) }

        // Seed budgets
        for b in Budget.mock { context.insert(b) }

        try context.save()
    }
}
