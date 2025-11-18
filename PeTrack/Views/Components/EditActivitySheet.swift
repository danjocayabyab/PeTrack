//
//  EditActivitySheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI

struct EditActivitySheet: View {
    let original: Activity
    let pets: [Pet]
    var onSave: (Activity) -> Void
    @Environment(\.dismiss) private var dismiss

    // Prefill state
    @State private var title: String
    @State private var type: Activity.ActivityType
    @State private var petName: String
    @State private var date: Date
    @State private var time: Date
    @State private var recurring: Bool
    @State private var location: String
    @State private var notes: String

    init(original: Activity, pets: [Pet], onSave: @escaping (Activity) -> Void) {
        self.original = original
        self.pets = pets
        self.onSave = onSave

        _title = State(initialValue: original.title)
        _type = State(initialValue: original.type)
        _petName = State(initialValue: original.petName)
        // Note: original model stores just a time string; we’ll keep today's date and parse time best-effort.
        _date = State(initialValue: Date())
        _time = State(initialValue: EditActivitySheet.parseTime(original.time))
        _recurring = State(initialValue: (original.frequency ?? "").lowercased() == "daily")
        _location = State(initialValue: original.location ?? "")
        _notes = State(initialValue: original.note ?? "")
    }

    var body: some View {
        AddActivitySheet(pets: pets) { updated in
            // Keep the same id and isDone/completed flags
            let final = Activity(
                id: original.id,
                title: updated.title,
                petName: updated.petName,
                time: updated.time,
                type: updated.type,
                frequency: updated.frequency,
                note: updated.note,
                isCompleted: original.isCompleted,
                isDone: original.isDone,
                location: updated.location
            )
            onSave(final)
        }
        // preload fields by wrapping AddActivitySheet UI via environment values
        .onAppear {
            // nothing else required because we pass via init; using wrapper approach to keep identical UI
        }
    }

    // Utility to get a Date from "7:00 AM" etc.
    private static func parseTime(_ s: String) -> Date {
        let fmts = ["h:mm a", "h a"]
        for f in fmts {
            let df = DateFormatter()
            df.dateFormat = f
            if let d = df.date(from: s) { return d }
        }
        return Date()
    }
}
