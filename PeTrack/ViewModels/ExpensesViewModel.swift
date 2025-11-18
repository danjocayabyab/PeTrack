//
//  ExpensesViewModel.swift
//  PeTrack
//
//  Created by STUDENT on 9/30/25.
//

// MARK: - ViewModels/ExpensesViewModel.swift
import Foundation
import SwiftUI

final class ExpensesViewModel: ObservableObject {
    enum Segment: String, CaseIterable { case expenses = "Expenses", budgets = "Budgets" }

    @Published var segment: Segment = .expenses
    @Published var expenses: [Expense] = Expense.mock
    @Published var budgets: [Budget]  = Budget.mock

    // MARK: - Actions
    func addBudget(_ b: Budget) {
        budgets.append(b)
        recalcBudgetsFromExpenses()
    }

    func addExpense(_ e: Expense) {
        expenses.insert(e, at: 0)
        // Update the matching budget's spent
        if let idx = budgets.firstIndex(where: { $0.category == e.category }) {
            budgets[idx].spent += e.amount
        } else {
            // If no budget exists, you can choose to silently ignore,
            // or uncomment to auto-create a zero-limit budget:
            // budgets.append(Budget(category: e.category, limit: 0, spent: e.amount, icon: e.icon, tintHex: e.tintHex))
            // For now we'll keep it simple and not auto-add.
        }
    }

    func editExpense(_ expense: Expense) {
        // (optional) could implement later
    }

    func deleteExpense(_ expense: Expense) {
        if let idx = expenses.firstIndex(where: { $0.id == expense.id }) {
            // Subtract from the matching budget if present
            let removed = expenses[idx]
            if let bIdx = budgets.firstIndex(where: { $0.category == removed.category }) {
                budgets[bIdx].spent = max(0, budgets[bIdx].spent - removed.amount)
            }
            expenses.remove(at: idx)
        }
    }

    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
    }

    // MARK: - Recalc helper (ensures consistency)
    func recalcBudgetsFromExpenses() {
        // zero out
        for i in budgets.indices { budgets[i].spent = 0 }
        // sum expenses by category
        for e in expenses {
            if let idx = budgets.firstIndex(where: { $0.category == e.category }) {
                budgets[idx].spent += e.amount
            }
        }
    }
}

