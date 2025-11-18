//
//  ScheduleViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/18/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published private(set) var scheduleActivities: [Activity] = []
    internal var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchActivities()
    }
    
    // MARK: - Computed Properties
    var todaysActivities: [Activity] {
        scheduleActivities.filter { activity in
            let calendar = Calendar.current
            return calendar.isDateInToday(activity.timestamp)
        }
    }
    
    // MARK: - Core Actions
    func markActivityAsDone(_ activity: Activity) {
        activity.isDone = true
        activity.isCompleted = true
        saveContext()
    }
    
    func deleteActivity(_ activity: Activity) {
        modelContext.delete(activity)
        saveContext()
        fetchActivities()
    }
    
    func addActivity(_ newActivity: Activity) {
        modelContext.insert(newActivity)
        saveContext()
        fetchActivities()
    }
    
    func updateActivity(_ updatedActivity: Activity) {
        saveContext()
        fetchActivities()
    }
    
    // MARK: - Data Operations
    func fetchActivities() {
        let descriptor = FetchDescriptor<Activity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        do {
            scheduleActivities = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch activities: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

