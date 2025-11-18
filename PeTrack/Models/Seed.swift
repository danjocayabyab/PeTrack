//
//  Seed.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import Foundation
import SwiftData

enum Seed {
    static func runIfEmpty(_ context: ModelContext) {
        // If pets already exist, assume seeded.
        let fetch = FetchDescriptor<Pet>()
        if let count = try? context.fetch(fetch).count, count > 0 { return }

        Pet.mockPets.forEach { context.insert($0) }
        Activity.mockScheduleActivities.forEach { context.insert($0) }
        Budget.mock.forEach { context.insert($0) }
        try? context.save()
    }
}
