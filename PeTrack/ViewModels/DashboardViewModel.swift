//
//  DashboardViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var pets: [Pet] = Pet.mockPets
    @Published var activities: [Activity] = Activity.mockActivities
    @Published var selectedTab = 0
    
    var totalPets: Int {
        pets.count
    }
    
    var todaysTasks: Int {
        activities.count
    }
    
    var completedTasks: Int {
        activities.filter { $0.isCompleted }.count
    }
    
    func toggleActivityCompletion(_ activity: Activity) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index].isCompleted.toggle()
        }
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
}
