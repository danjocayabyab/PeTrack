//
//  ActivityDetailSheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI

struct ActivityDetailSheet: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Header icon + title
                    HStack(spacing: 12) {
                        Circle()
                            .fill(typeColor.opacity(0.15))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: typeSymbol)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(typeColor)
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text(activity.title)
                                .font(.system(size: 22, weight: .bold))
                            HStack(spacing: 8) {
                                Pill(text: activity.petName)
                                if let f = activity.frequency, !f.isEmpty { Pill(text: f) }
                                if activity.isDone { Pill(text: "Done", tint: .green) }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 6)
                    .padding(.horizontal)

                    // Info card
                    VStack(alignment: .leading, spacing: 14) {
                        Row(label: "Time", value: activity.time)
                        if let loc = activity.location, !loc.isEmpty {
                            Row(label: "Location", value: loc)
                        }
                        Row(label: "Type", value: displayName(for: activity.type))
                        if let f = activity.frequency, !f.isEmpty {
                            Row(label: "Frequency", value: f.capitalized)
                        }
                        if let note = activity.note, !note.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                                Text(note)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.top, 6)
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.12)))
                    .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
                    .padding(.horizontal)

                    Spacer(minLength: 16)
                }
                .padding(.bottom, 24)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }

    // MARK: - Helpers
    private var typeColor: Color {
        switch activity.type {
        case .morningWalk, .walk: return .green
        case .feeding, .breakfast, .dinner: return .orange
        case .grooming: return .purple
        case .vetVisit: return .red
        }
    }
    private var typeSymbol: String {
        switch activity.type {
        case .morningWalk, .walk: return "figure.walk"
        case .feeding, .breakfast, .dinner: return "fork.knife"
        case .grooming: return "scissors"
        case .vetVisit: return "cross.case"
        }
    }
    private func displayName(for t: Activity.ActivityType) -> String {
        switch t {
        case .feeding: return "Feeding"
        case .walk: return "Walk"
        case .vetVisit: return "Vet Visit"
        case .grooming: return "Grooming"
        case .morningWalk: return "Morning Walk"
        case .breakfast: return "Breakfast"
        case .dinner: return "Dinner"
        }
    }
}

private struct Row: View {
    let label: String; let value: String
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).foregroundColor(.secondary)
            Spacer()
            Text(value).fontWeight(.semibold)
        }
        .font(.system(size: 16))
    }
}

private struct Pill: View {
    let text: String
    var tint: Color = .gray
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(tint.opacity(0.14))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
