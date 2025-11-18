//
//  ScheduleActivityCard.swift
//  PeTrack
//
//  Created by STUDENT on 9/18/25.
//

// MARK: - Views/Components/ScheduleActivityCard.swift
import SwiftUI

struct ScheduleActivityCard: View {
    let activity: Activity
    let onMarkDone: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            LeadingIcon(type: activity.type)

            VStack(alignment: .leading, spacing: 8) {
                TitleRow(title: activity.title, petName: activity.petName, frequency: activity.frequency)
                TimeRow(time: activity.time)

                if let note = activity.note, !note.isEmpty {
                    NoteRow(note: note)
                }
            }
            .layoutPriority(1)

            HStack(spacing: 8) {
                MarkDonePill(isDone: activity.isDone, action: onMarkDone)
                IconSquareButton(systemName: "pencil", tint: .blue, action: onEdit)
                IconSquareButton(systemName: "trash",  tint: .red,  action: onDelete)
            }
            .fixedSize(horizontal: true, vertical: true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08), lineWidth: 0.8))
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Pieces (no duplicate helpers here)

private struct LeadingIcon: View {
    let type: Activity.ActivityType
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 26, height: 26)
            .overlay(
                Image(systemName: symbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            )
    }
    private var color: Color {
        switch type {
        case .morningWalk, .walk: return .green
        case .feeding, .breakfast, .dinner: return .orange
        case .grooming: return .purple
        case .vetVisit: return .red
        }
    }
    private var symbol: String {
        switch type {
        case .morningWalk, .walk: return "figure.walk"
        case .feeding, .breakfast, .dinner: return "fork.knife"
        case .grooming: return "scissors"
        case .vetVisit: return "cross.case"
        }
    }
}

private struct TitleRow: View {
    let title: String
    let petName: String
    let frequency: String?
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.9)

            PillBadge(text: petName)
            if let f = frequency, !f.isEmpty { PillBadge(text: f) }

            Spacer(minLength: 0)
        }
    }
}

private struct TimeRow: View {
    let time: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Text(time)
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            Spacer(minLength: 0)
        }
    }
}

private struct NoteRow: View {
    let note: String
    var body: some View {
        Text(note)
            .font(.system(size: 13))
            .foregroundColor(.gray)
            .lineLimit(1)
            .truncationMode(.tail)
            .minimumScaleFactor(0.9)
    }
}

private struct MarkDonePill: View {
    let isDone: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(isDone ? "Done" : "Mark Done")
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 12).fill(isDone ? Color.green.opacity(0.12) : Color.blue.opacity(0.10)))
                .foregroundColor(isDone ? .green : .blue)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isDone ? Color.green.opacity(0.35) : Color.blue.opacity(0.35), lineWidth: 0.9))
        }
        .buttonStyle(.plain)
        .fixedSize()
    }
}
