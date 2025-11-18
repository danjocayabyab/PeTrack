//
//  ExpenseRow.swift
//  PeTrack
//
//  Created by STUDENT on 9/30/25.
//

// MARK: - Views/Components/ExpenseRow.swift
// MARK: - Views/Components/ExpenseRow.swift
import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Leading icon
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 38, height: 38)
                Image(systemName: expense.icon)
                    .font(.system(size: 16, weight: .semibold))
            }

            // Title + chips + meta
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(expense.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)

                    // Chips
                    Chip(expense.petName)
                    Chip(expense.category)
                }

                HStack(spacing: 10) {
                    if let store = expense.store, !store.isEmpty {
                        Text(store).foregroundColor(.secondary)
                    }
                    Text(dateString(expense.date))
                        .foregroundColor(.secondary)
                }
                .font(.system(size: 12))
            }

            Spacer()

            // Amount + actions
            VStack(alignment: .trailing, spacing: 8) {
                Text(peso(expense.amount))   // <-- amount is Double now
                    .font(.system(size: 16, weight: .semibold))

                HStack(spacing: 10) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.blue))
                    }
                    .buttonStyle(.plain)

                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(RoundedRectangle(cornerRadius: 6).fill(Color.red))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.black.opacity(0.12), lineWidth: 1)
        )
    }

    // MARK: Helpers

    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d, yyyy • h:mm a"
        return f.string(from: date)
    }

    private func peso(_ amount: Double) -> String {
        if ExpenseRow.currencyFormatter.currencySymbol != "₱" {
            ExpenseRow.currencyFormatter.currencySymbol = "₱"
        }
        return ExpenseRow.currencyFormatter.string(from: NSNumber(value: amount)) ?? "₱0.00"
    }

    private static let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "₱"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }()
}

private struct Chip: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemGray6)))
    }
}
