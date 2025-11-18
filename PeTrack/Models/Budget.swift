//
//  Budget.swift
//  PeTrack
//
//  Created by STUDENT on 9/30/25.
//

import Foundation
import SwiftData

@Model
final class Budget {
    var id: UUID
    var category: String
    var limit: Double
    var spent: Double
    var icon: String
    var tintHex: String
    var alertThreshold: Int   // 0..100

    init(id: UUID = UUID(),
         category: String,
         limit: Double,
         spent: Double,
         icon: String,
         tintHex: String,
         alertThreshold: Int = 80) {
        self.id = id
        self.category = category
        self.limit = limit
        self.spent = spent
        self.icon = icon
        self.tintHex = tintHex
        self.alertThreshold = alertThreshold
    }

    var progress: Double {
        guard limit > 0 else { return 0 }
        return min(max(spent / limit, 0), 1)
    }

    static let mock: [Budget] = [
        Budget(category: "Food & Treats",      limit: 3000, spent: 1500, icon: "bag.fill",         tintHex: "#F59E0B"),
        Budget(category: "Medical & Vet",      limit: 5000, spent: 1000, icon: "stethoscope",      tintHex: "#7C3AED"),
        Budget(category: "Grooming",           limit: 2000, spent: 700,  icon: "scissors",         tintHex: "#EC4899"),
        Budget(category: "Toys & Accessories", limit: 1500, spent: 300,  icon: "puzzlepiece.fill", tintHex: "#22C55E")
    ]
}
