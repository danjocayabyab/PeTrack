//
//  AddActivitySheet.swift.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI

struct AddActivitySheet: View {
    // Provide list of pets for the "Pet" picker
    let pets: [Pet]
    var isEditMode: Bool = false
    var onSave: (Activity) -> Void
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var title: String = ""
    @State private var type: Activity.ActivityType = .feeding
    @State private var petName: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var recurring: Bool = false
    @State private var location: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text(isEditMode ? "Edit Activity" : "Add New Activity")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.top, 6)

                    Text(isEditMode ? "Update the scheduled activity for your pet." : "Create a new scheduled activity for your pet.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Group {
                        Labeled("Activity Title") {
                            TextField("e.g., Morning Walk, Vet Check Up", text: $title)
                                .textFieldStyle(SoftFieldStyle())
                        }

                        Labeled("Activity Type") {
                            Picker("", selection: $type) {
                                ForEach(Activity.ActivityType.allCases, id: \.self) { t in
                                    Text(displayName(for: t)).tag(t)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                        }

                        Labeled("Pet") {
                            Picker(petName.isEmpty ? "Select a Pet" : petName, selection: $petName) {
                                Text("Select a Pet").tag("")
                                ForEach(pets) { p in
                                    Text(p.name).tag(p.name)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                        }

                        HStack(spacing: 12) {
                            Labeled("Date") {
                                DatePicker("", selection: $date, displayedComponents: [.date])
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                            }
                            Labeled("Time") {
                                DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                            }
                        }

                        Toggle(isOn: $recurring) {
                            Text("Recurring Activity").font(.system(size: 15, weight: .semibold))
                        }
                        .padding(.top, 4)

                        Labeled("Location (optional)") {
                            TextField("e.g., Local Park, Vet Clinic", text: $location)
                                .textFieldStyle(SoftFieldStyle())
                        }

                        Labeled("Notes (Optional)") {
                            TextField("Additional Notes or instructions", text: $notes, axis: .vertical)
                                .lineLimit(3, reservesSpace: true)
                                .textFieldStyle(SoftFieldStyle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
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
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 14) {
                    Button {
                        handleSave()
                    } label: {
                        Text(isEditMode ? "Save Changes" : "Add Activity")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.black))
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.35)))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
        }
    }

    private func handleSave() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !petName.isEmpty else { return }

        // Merge chosen date+time, but your model stores time as String – we’ll format display time.
        let displayTime = time.formatted(date: .omitted, time: .shortened)

        let activity = Activity(
            title: title,
            petName: petName,
            time: displayTime,
            type: type,
            frequency: recurring ? "daily" : nil,
            note: notes.isEmpty ? nil : notes,
            location: location.isEmpty ? nil : location
        )

        onSave(activity)
        dismiss()
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

// Small helpers used in the form
private struct Labeled<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title; self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 14, weight: .semibold))
            content
        }
    }
}

private struct SoftFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
    }
}
