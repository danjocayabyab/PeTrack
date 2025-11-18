//
//  DashboardView.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

// MARK: - Views/DashboardView.swift
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
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
    
    // MARK: Header (unchanged)
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
                Text("Today is \(viewModel.getCurrentDate())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.top, 20)
    }
    
    // MARK: Stats (match StatCard API: icon, number, title, backgroundColor)
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "🐾",
                number: "\(viewModel.totalPets)",
                title: "Total Pets",
                backgroundColor: Color.blue.opacity(0.8)
            )
            StatCard(
                icon: "📋",
                number: "\(viewModel.todaysTasks)",
                title: "Today's Tasks",
                backgroundColor: Color.blue.opacity(0.6)
            )
            StatCard(
                icon: "✓",
                number: "\(viewModel.completedTasks)",
                title: "Completed",
                backgroundColor: Color.blue.opacity(0.4)
            )
        }
    }
    
    // MARK: Activities (match ActivityRow API: activity, onToggle)
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
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.activities) { activity in
                    ActivityRow(activity: activity) {
                        viewModel.toggleActivityCompletion(activity)
                    }
                }
            }
        }
    }
    
    // MARK: My Pets
    private var petsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("My Pets")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(viewModel.pets) { pet in
                    PetCard(pet: pet)
                }
            }
        }
    }
}
