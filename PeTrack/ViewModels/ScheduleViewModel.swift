//
//  ScheduleViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/18/25.
//

import Foundation
import SwiftUI

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published var scheduleActivities: [Activity] = Activity.mockScheduleActivities
    
    // MARK: - Computed Properties
    var todaysActivities: [Activity] {
        scheduleActivities
    }
    
    // MARK: - Core Actions
    func markActivityAsDone(_ activity: Activity) {
        if let index = scheduleActivities.firstIndex(where: { $0.id == activity.id }) {
            scheduleActivities[index].isDone = true
            scheduleActivities[index].isCompleted = true
        }
    }
    
    func deleteActivity(_ activity: Activity) {
        scheduleActivities.removeAll { $0.id == activity.id }
    }
    
    func addActivity(_ newActivity: Activity) {
        // Add at the top for visibility
        scheduleActivities.insert(newActivity, at: 0)
    }
    
    func updateActivity(_ updatedActivity: Activity) {
        if let index = scheduleActivities.firstIndex(where: { $0.id == updatedActivity.id }) {
            scheduleActivities[index] = updatedActivity
        }
    }
    
    // MARK: - Helpers
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

