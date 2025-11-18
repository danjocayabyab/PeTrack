//
//  Activity.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

//bagoooo
//bagoooo
//ano naaa

import Foundation
import SwiftData

@Model
final class Activity {
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

    var id: UUID
    var title: String
    var petName: String
    var time: String
    var type: ActivityType
    var frequency: String?
    var note: String?
    var isCompleted: Bool
    var isDone: Bool
    var location: String?

    init(id: UUID = UUID(),
         title: String,
         petName: String,
         time: String,
         type: ActivityType,
         frequency: String? = nil,
         note: String? = nil,
         isCompleted: Bool = false,
         isDone: Bool = false,
         location: String? = nil) {
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
    }

    static let mockScheduleActivities: [Activity] = [
        Activity(title: "Morning Walk", petName: "Buddy", time: "7:00 AM", type: .morningWalk, frequency: "daily", note: "Regular morning exercise", location: "Neighborhood Park"),
        Activity(title: "Breakfast",    petName: "Buddy", time: "8:00 AM", type: .breakfast,   frequency: "daily"),
        Activity(title: "Dinner",       petName: "Luna",  time: "6:00 PM", type: .dinner,      frequency: "daily")
    ]
}
