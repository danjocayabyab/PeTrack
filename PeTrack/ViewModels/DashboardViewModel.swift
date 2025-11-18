//
//  DashboardViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class DashboardViewModel: ObservableObject {
    @Published private(set) var pets: [Pet] = []
    @Published private(set) var activities: [Activity] = []
    @Published var selectedTab = 0
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchPets()
        fetchActivities()
    }
    
    var totalPets: Int {
        pets.count
    }
    
    var todaysTasks: Int {
        activities.count
    }
    
    var completedTasks: Int {
        activities.filter { $0.isCompleted }.count
    }
    
    // MARK: - Activity Management
    func toggleActivityCompletion(_ activity: Activity) {
        activity.isCompleted.toggle()
        saveContext()
    }
    
    func addActivity(_ activity: Activity) {
        modelContext.insert(activity)
        saveContext()
        fetchActivities()
    }
    
    func updateActivity(_ activity: Activity) {
        saveContext()
        fetchActivities()
    }
    
    func deleteActivity(_ activity: Activity) {
        modelContext.delete(activity)
        saveContext()
        fetchActivities()
    }
    
    // MARK: - Private Helpers
    private func fetchActivities() {
        let descriptor = FetchDescriptor<Activity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        do {
            activities = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch activities: \(error.localizedDescription)")
        }
    }
    
    private func fetchPets() {
        let descriptor = FetchDescriptor<Pet>(
            sortBy: [SortDescriptor(\.name)]
        )
        do {
            pets = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch pets: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
}
