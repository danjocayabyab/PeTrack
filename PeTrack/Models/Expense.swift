//
//  Expense.swift
//  PeTrack
//
//  Created by STUDENT on 9/30/25.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var id: UUID
    var title: String
    var petName: String
    var category: String
    var amount: Double
    var date: Date
    var store: String?
    var notes: String?
    var isRecurring: Bool
    var icon: String
    var tintHex: String

    init(id: UUID = UUID(),
         title: String,
         petName: String,
         category: String,
         amount: Double,
         date: Date,
         store: String? = nil,
         notes: String? = nil,
         isRecurring: Bool = false,
         icon: String = "creditcard",
         tintHex: String = "#0EA5E9") {
        self.id = id
        self.title = title
        self.petName = petName
        self.category = category
        self.amount = amount
        self.date = date
        self.store = store
        self.notes = notes
        self.isRecurring = isRecurring
        self.icon = icon
        self.tintHex = tintHex
    }

    static let mock: [Expense] = []
}
