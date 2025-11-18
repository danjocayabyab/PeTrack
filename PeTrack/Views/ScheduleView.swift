//
//  ScheduleView.swift
//  PeTrack
//
//  Created by STUDENT on 9/18/25.
//

import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) private var modelContext

    // Local UI state
    @State private var showAdd = false
    @State private var showEdit = false
    @State private var showDetail = false
    @State private var selectedActivity: Activity?

    // We still keep your simple in-memory VM to drive the UI
    @StateObject private var viewModel = ScheduleViewModel()

    // Pets for the picker (you can switch to @Query later)
    @Query(sort: \Pet.name) private var pets: [Pet]

    var body: some View {
        VStack(spacing: 0) {
            headerSection

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack { Spacer(); AddActivityButton(action: { showAdd = true }) }
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 10) {
                            Circle().fill(Color.blue.opacity(0.9))
                                .frame(width: 26, height: 26)
                                .overlay(Image(systemName: "clock").font(.system(size: 13, weight: .bold)).foregroundColor(.white))
                            Text("Today’s Schedule").font(.system(size: 20, weight: .semibold))
                            Spacer()
                        }
                        .padding(.top, 12).padding(.horizontal, 12)

                        if viewModel.todaysActivities.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.clock").font(.system(size: 44)).foregroundColor(.gray.opacity(0.5))
                                Text("No activities scheduled for today").font(.system(size: 15)).foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 24)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(viewModel.todaysActivities, id: \.id) { activity in
                                    ScheduleActivityCard(
                                        activity: activity,
                                        onMarkDone: {
                                            viewModel.markActivityAsDone(activity)
                                            if let stored = try? fetchActivity(by: activity.id) {
                                                stored.isDone = true
                                                stored.isCompleted = true
                                                try? modelContext.save()
                                            }
                                        },
                                        onEdit: {
                                            selectedActivity = try? fetchActivity(by: activity.id)
                                            showEdit = selectedActivity != nil
                                        },
                                        onDelete: {
                                            viewModel.deleteActivity(activity)
                                            if let stored = try? fetchActivity(by: activity.id) {
                                                modelContext.delete(stored)
                                                try? modelContext.save()
                                            }
                                        }
                                    )
                                    .contentShape(Rectangle())
                                    .onTapGesture { selectedActivity = activity; showDetail = true }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 14)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal)

                    Spacer(minLength: 28)
                }
                .padding(.top, 16)
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
        // Sheets
        .sheet(isPresented: $showAdd) {
            AddActivitySheet(pets: pets.isEmpty ? Pet.mockPets : pets) { new in
                // persist
                modelContext.insert(new)
                try? modelContext.save()
                // keep VM in sync
                viewModel.addActivity(new)
            }
            .presentationDetents([.large])
        }
        .sheet(isPresented: $showEdit) {
            if let act = selectedActivity {
                EditActivitySheet(original: act, pets: pets.isEmpty ? Pet.mockPets : pets) { updated in
                    // update stored object fields
                    act.title = updated.title
                    act.petName = updated.petName
                    act.time = updated.time
                    act.type = updated.type
                    act.frequency = updated.frequency
                    act.note = updated.note
                    act.location = updated.location
                    try? modelContext.save()
                    viewModel.updateActivity(act)
                }
                .presentationDetents([.large])
            }
        }
        .sheet(isPresented: $showDetail) {
            if let act = selectedActivity {
                ActivityDetailSheet(activity: act)
            }
        }
        .onAppear {
            // Bootstrap VM from SwiftData (once)
            if viewModel.todaysActivities.isEmpty {
                let fd = FetchDescriptor<Activity>()
                if let stored = try? modelContext.fetch(fd), !stored.isEmpty {
                    viewModel.scheduleActivities = stored
                } else {
                    // fall back to mocks (and persist them once)
                    viewModel.scheduleActivities = Activity.mockScheduleActivities
                    Activity.mockScheduleActivities.forEach { modelContext.insert($0) }
                    try? modelContext.save()
                }
            }
        }
    }

    private func fetchActivity(by id: UUID) throws -> Activity? {
        let d = FetchDescriptor<Activity>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(d).first
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("Schedule").font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                Image(systemName: "calendar").font(.title2).foregroundColor(.white)
                Spacer()
            }
            HStack {
                Text("Manage Your Pet Activities").font(.system(size: 18)).foregroundColor(.white.opacity(0.92))
                Spacer()
            }
        }
        .padding(.horizontal).padding(.top, 50).padding(.bottom, 20)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.blue.opacity(0.55)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

private struct AddActivityButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "plus").font(.system(size: 16, weight: .semibold))
                Text("Add Activity").font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 18).padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.3), lineWidth: 1))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}
