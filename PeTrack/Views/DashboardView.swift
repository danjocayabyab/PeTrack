//
//  DashboardView.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

// MARK: - Views/DashboardView.swift
import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pet.name) private var pets: [Pet]
    @Query(sort: \Activity.timestamp, order: .reverse) private var activities: [Activity]
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: Date())
    }
    
    private var todaysActivities: [Activity] {
        let calendar = Calendar.current
        return activities.filter { activity in
            calendar.isDateInToday(activity.timestamp)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Stats Cards
                statsSection
                
                // Today's Activities
                activitiesSection
                
                // My Pets
                petsSection
            }
            .padding(.horizontal)
            .padding(.bottom, 100) // space for tab bar
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Welcome Back!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.blue)
                }
                Text("Today is \(formattedDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.top, 20)
    }
    
    // MARK: Stats
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "🐾",
                number: "\(pets.count)",
                title: "Total Pets",
                backgroundColor: Color.blue.opacity(0.8)
            )
            StatCard(
                icon: "📋",
                number: "\(todaysActivities.count)",
                title: "Today's Tasks",
                backgroundColor: Color.blue.opacity(0.6)
            )
            StatCard(
                icon: "✓",
                number: "\(todaysActivities.filter { $0.isCompleted }.count)",
                title: "Completed",
                backgroundColor: Color.blue.opacity(0.4)
            )
        }
    }
    
    // MARK: Activities Section
    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Today's Activities")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if todaysActivities.isEmpty {
                Text("No activities for today")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(todaysActivities) { activity in
                        ActivityRow(activity: activity) {
                            activity.isCompleted.toggle()
                            do {
                                try modelContext.save()
                            } catch {
                                print("Failed to update activity: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: My Pets
    private var petsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "pawprint.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("My Pets")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink(destination: MyPetsView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            if pets.isEmpty {
                Text("No pets added yet")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(pets.prefix(5)) { pet in
                            PetCard(pet: pet)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
