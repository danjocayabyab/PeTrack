//
//  AddExpenseSheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI

struct AddExpenseSheet: View {
    let pets: [Pet]
    let existingBudgets: [Budget]
    var onSave: (Expense) -> Void
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var category: String = ""
    @State private var petName: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var store: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {

                    // Header
                    VStack(spacing: 6) {
                        Text("Add New Expense")
                            .font(.system(size: 22, weight: .bold))
                        Text("Record a new expense for your pet.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 8)

                    // Title
                    Labeled("Expense Title") {
                        TextField("e.g., Dog Food, Vet Visit", text: $title)
                            .textFieldStyle(SoftFieldStyle())
                    }

                    // Amount | Time
                    HStack(spacing: 12) {
                        Labeled("Amount") {
                            TextField("0.00", text: $amountText)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(SoftFieldStyle())
                        }
                        Labeled("Time") {
                            DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12).padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "clock")
                                        .foregroundColor(.secondary)
                                        .padding(.trailing, 10)
                                }
                        }
                    }

                    // Category | Pet
                    HStack(spacing: 12) {
                        Labeled("Category") {
                            Picker("", selection: $category) {
                                Text("Select a Category").tag("")
                                ForEach(existingBudgets) { b in
                                    Text(b.category).tag(b.category)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12).padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                        }
                        Labeled("Pet") {
                            Picker("Select a Pet", selection: $petName) {
                                Text("Select a Pet").tag("")
                                ForEach(pets) { p in Text(p.name).tag(p.name) }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12).padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                            .overlay(alignment: .trailing) {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 10)
                            }
                        }
                    }

                    // Date | Time (mirrors your mock layout)
                    HStack(spacing: 12) {
                        Labeled("Date") {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12).padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                        }
                        Labeled("Date") {   // keeping the label per your mock; this is the time control
                            DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12).padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "clock")
                                        .foregroundColor(.secondary)
                                        .padding(.trailing, 10)
                                }
                        }
                    }

                    // Vendor / Notes
                    Labeled("Vendor/Store (optional)") {
                        TextField("e.g., Pet Store, Vet Clinic", text: $store)
                            .textFieldStyle(SoftFieldStyle())
                    }
                    Labeled("Description (Optional)") {
                        TextField("Additional notes about this expense", text: $notes, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .textFieldStyle(SoftFieldStyle())
                    }

                    // Buttons
                    HStack(spacing: 14) {
                        Button(action: handleSave) {
                            Text("Add Expense")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black))
                        }
                        Button(action: { dismiss() }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.35)))
                        }
                    }
                    .padding(.vertical, 6)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
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

    // MARK: Save (uses Double now)
    private func handleSave() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !petName.isEmpty, !category.isEmpty
        else { return }

        // Convert amount text to Double (SwiftData model expects Double)
        let cleaned = amountText.replacingOccurrences(of: ",", with: "")
        guard let amount = Double(cleaned) else { return }

        // pick icon/tint from chosen budget if available
        let match = existingBudgets.first(where: { $0.category == category })
        let icon  = match?.icon ?? "creditcard"
        let tint  = match?.tintHex ?? "#0EA5E9"

        // combine date + time into one Date for storage
        let calendar = Calendar.current
        let t = calendar.dateComponents([.hour, .minute], from: time)
        let finalDate = calendar.date(bySettingHour: t.hour ?? 0, minute: t.minute ?? 0, second: 0, of: date) ?? date

        let exp = Expense(
            title: title,
            petName: petName,
            category: category,
            amount: amount,      // <-- Double
            date: finalDate,
            store: store.isEmpty ? nil : store,
            notes: notes.isEmpty ? nil : notes,
            isRecurring: false,
            icon: icon,
            tintHex: tint
        )
        onSave(exp)
        dismiss()
    }
}

// MARK: - Local helpers (so this file compiles standalone)

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
