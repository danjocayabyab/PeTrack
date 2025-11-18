//
//  BudgetRow.swift
//  PeTrack
//
//  Created by STUDENT on 9/30/25.
//

// MARK: - Views/Components/BudgetRow.swift
// MARK: - Views/Components/BudgetRow.swift
import SwiftUI

struct BudgetRow: View {
    let budget: Budget
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left icon
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 38, height: 38)
                Image(systemName: budget.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(colorFromHex(budget.tintHex))
            }

            // Title + progress
            VStack(alignment: .leading, spacing: 8) {
                Text(budget.category)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text("\(peso(budget.spent)) of \(peso(budget.limit))")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                // Progress bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    GeometryReader { geo in
                        Capsule()
                            .fill(colorFromHex(budget.tintHex))
                            .frame(
                                width: max(0, min(geo.size.width, geo.size.width * budget.progress)),
                                height: 8
                            )
                    }
                    .frame(height: 8)
                }
                .clipShape(Capsule())
            }

            Spacer()

            // Delete
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.red))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.12), lineWidth: 1))
    }

    // MARK: - Helpers (Double-based)

    private func peso(_ value: Double) -> String {
        if BudgetRow.currencyFormatter.currencySymbol != "₱" {
            BudgetRow.currencyFormatter.currencySymbol = "₱"
        }
        return BudgetRow.currencyFormatter.string(from: NSNumber(value: value)) ?? "₱0.00"
    }

    private static let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "₱"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }()

    private func colorFromHex(_ hex: String) -> Color {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}
