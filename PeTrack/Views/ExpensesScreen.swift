import SwiftUI
import SwiftData

struct ExpensesScreen: View {
    @Environment(\.modelContext) private var modelContext

    // Pull budgets/expenses from SwiftData (simple & reliable)
    @Query(sort: \Budget.category) private var budgets: [Budget]
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    // UI state
    enum Segment: String, CaseIterable { case expenses = "Expenses", budgets = "Budgets" }
    @State private var segment: Segment = .expenses
    @State private var showAddExpense = false
    @State private var showAddBudget  = false
    @State private var alertBudget: Budget?

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: 16) {
                    SegmentedPills(selected: $segment)
                    container
                }
                .padding(.top, 18)
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
        // Sheets
        .sheet(isPresented: $showAddExpense) {
            AddExpenseSheet(pets: Pet.mockPets, existingBudgets: budgets) { new in
                // persist expense
                modelContext.insert(new)
                // bump the matching budget
                if let b = budgets.first(where: { $0.category == new.category }) {
                    b.spent += new.amount
                    maybeAlert(b)
                }
                try? modelContext.save()
            }
            .presentationDetents([.large])
        }
        .sheet(isPresented: $showAddBudget) {
            AddBudgetSheet { new in
                modelContext.insert(new)
                try? modelContext.save()
            }
            .presentationDetents([.large])
        }
        // Overspend alert
        .alert(item: $alertBudget) { b in
            Alert(
                title: Text("Budget Alert"),
                message: Text("₱\(Int(b.spent)) of ₱\(Int(b.limit)) in “\(b.category)”. You’ve reached \(b.alertThreshold)% of your budget."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: UI

    private var header: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Text("Expenses").font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                Image(systemName: "calendar").font(.title2).foregroundColor(.white)
                Spacer()
            }
            HStack {
                Text("Track Your Pet Spending").font(.system(size: 18)).foregroundColor(.white.opacity(0.92))
                Spacer()
            }
        }
        .padding(.horizontal).padding(.top, 50).padding(.bottom, 22)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.blue.opacity(0.55)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }

    private var container: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Circle().fill(Color.black.opacity(0.85)).frame(width: 24, height: 24)
                    .overlay(Image(systemName: segment == .expenses ? "list.bullet.rectangle" : "wallet.pass").font(.system(size: 12, weight: .bold)).foregroundColor(.white))
                Text(segment == .expenses ? "All Expenses" : "Budget Management")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                AddButton(title: segment == .expenses ? "Add Expense" : "Add Budget") {
                    if segment == .expenses { showAddExpense = true } else { showAddBudget = true }
                }
            }
            .padding(.top, 12).padding(.horizontal, 12)

            if segment == .expenses {
                VStack(spacing: 12) {
                    ForEach(expenses, id: \.id) { e in
                        ExpenseRow(expense: e,
                                   onEdit: { /* hook up later */ },
                                   onDelete: {
                                       if let b = budgets.first(where: { $0.category == e.category }) {
                                           b.spent = max(0, b.spent - e.amount)
                                       }
                                       modelContext.delete(e)
                                       try? modelContext.save()
                                   })
                    }
                }
                .padding(.horizontal, 12).padding(.bottom, 14)
            } else {
                VStack(spacing: 12) {
                    ForEach(budgets, id: \.id) { b in
                        BudgetRow(budget: b) {
                            modelContext.delete(b)
                            try? modelContext.save()
                        }
                    }
                }
                .padding(.horizontal, 12).padding(.bottom, 14)
            }
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.2), lineWidth: 1))
        .padding(.horizontal)
    }

    private func maybeAlert(_ b: Budget) {
        if b.progress >= Double(b.alertThreshold) / 100.0 {
            alertBudget = b
        }
    }
}

// Helpers included in-file so it compiles standalone

private struct SegmentedPills: View {
    @Binding var selected: ExpensesScreen.Segment
    var body: some View {
        HStack(spacing: 0) {
            pill(.expenses)
            pill(.budgets)
        }
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.15)))
        .padding(.horizontal)
    }
    private func pill(_ seg: ExpensesScreen.Segment) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { selected = seg }
        } label: {
            Text(seg.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(selected == seg ? .white : .primary)
                .frame(maxWidth: .infinity).padding(.vertical, 10)
                .background(selected == seg ? AnyView(RoundedRectangle(cornerRadius: 10).fill(Color.black)) : AnyView(Color.clear))
        }
        .buttonStyle(.plain)
    }
}

private struct AddButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "plus").font(.system(size: 16, weight: .semibold))
                Text(title).font(.system(size: 16, weight: .semibold))
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

