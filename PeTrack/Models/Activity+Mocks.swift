//
//  Activity+Mocks.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import Foundation
import SwiftData

// Keep dashboard mock data here so DashboardViewModel compiles.
extension Activity {
    static let mockActivities: [Activity] = [
        Activity(title: "Feeding",
                 petName: "Buddy",
                 time: "8:00 AM",
                 type: .feeding,
                 isCompleted: true),

        Activity(title: "Walk",
                 petName: "Luna",
                 time: "10:30 AM",
                 type: .walk),

        Activity(title: "Vet Visit",
                 petName: "Buddy",
                 time: "2:00 PM",
                 type: .vetVisit),

        Activity(title: "Grooming",
                 petName: "Max",
                 time: "4:00 PM",
                 type: .grooming)
    ]
}
