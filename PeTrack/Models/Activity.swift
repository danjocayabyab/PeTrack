//
//  Activity.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Activity: Identifiable {
    // Add a version identifier for model migration
    static let schemaVersion = "ActivityV2"
    enum ActivityType: String, CaseIterable, Codable {
        case feeding = "feeding"
        case walk = "walk"
        case vetVisit = "vet"
        case grooming = "grooming"
        case morningWalk = "morning_walk"
        case breakfast = "breakfast"
        case dinner = "dinner"

        var icon: String {
            switch self {
            case .feeding, .breakfast, .dinner: return "🥣"
            case .walk, .morningWalk:          return "🌍"
            case .vetVisit:                     return "🏥"
            case .grooming:                     return "✂️"
            }
        }
        
        var color: String {
            switch self {
            case .morningWalk, .walk:           return "green"
            case .breakfast, .dinner, .feeding: return "orange"
            case .grooming:                     return "purple"
            case .vetVisit:                     return "red"
            }
        }
    }
    
    @Attribute(.unique) var id: UUID
    var title: String
    var petName: String
    var time: String
    var type: ActivityType
    var frequency: String?
    var note: String?
    var isCompleted: Bool
    var isDone: Bool
    var location: String?
    var timestamp: Date = Date()
    
    init(id: UUID = UUID(),
         title: String,
         petName: String,
         time: String,
         type: ActivityType,
         frequency: String? = nil,
         note: String? = nil,
         isCompleted: Bool = false,
         isDone: Bool = false,
         location: String? = nil,
         timestamp: Date = .now) {
        self.id = id
        self.title = title
        self.petName = petName
        self.time = time
        self.type = type
        self.frequency = frequency
        self.note = note
        self.isCompleted = isCompleted
        self.isDone = isDone
        self.location = location
        self.timestamp = timestamp
    }
}
