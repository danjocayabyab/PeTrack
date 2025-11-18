//
//  AddBudgetSheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI

struct AddBudgetSheet: View {
    var onSave: (Budget) -> Void
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var category: String = ""
    @State private var limitText: String = ""
    @State private var alertThresholdText: String = "80" // percent
    @State private var icon: String = "bag.fill"
    @State private var tintHex: String = "#F59E0B"

    // Suggested categories
    private let presets: [(name: String, icon: String, tint: String)] = [
        ("Food & Treats",        "bag.fill",         "#F59E0B"),
        ("Medical & Vet",        "stethoscope",      "#7C3AED"),
        ("Grooming",             "scissors",         "#EC4899"),
        ("Toys & Accessories",   "puzzlepiece.fill", "#22C55E"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 6) {
                        Text("Set Category Budget")
                            .font(.system(size: 22, weight: .bold))
                        Text("Set a monthly spending limit for a category.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 8)

                    Labeled("Category") {
                        Picker("", selection: $category) {
                            Text("Select a Category").tag("")
                            ForEach(presets, id: \.name) { p in
                                Text(p.name).tag(p.name)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12).padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
                        .onChange(of: category) { new in
                            if let p = presets.first(where: { $0.name == new }) {
                                icon = p.icon; tintHex = p.tint
                            }
                        }
                    }

                    Labeled("Monthly Limit") {
                        TextField("100.00", text: $limitText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(SoftFieldStyle())
                    }

                    Labeled("Alert Threshold (%)") {
                        TextField("80", text: $alertThresholdText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(SoftFieldStyle())
                        Text("You'll be alerted when spending reaches this percentage")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }

                    HStack(spacing: 14) {
                        Button(action: handleSave) {
                            Text("Set Budget")
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
        guard !category.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let cleaned = limitText.replacingOccurrences(of: ",", with: "")
        guard let limit = Double(cleaned) else { return }           // <-- Double
        let threshold = Int(alertThresholdText) ?? 80

        let b = Budget(category: category,
                       limit: limit,                                // <-- Double
                       spent: 0,
                       icon: icon,
                       tintHex: tintHex,
                       alertThreshold: threshold)
        onSave(b)
        dismiss()
    }
}

// MARK: - Local helpers so this file compiles standalone

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
