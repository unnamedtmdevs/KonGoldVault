//
//  ExpenseViewModel.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = DataService.shared
    private let analyticsService = AnalyticsService.shared
    
    init() {
        loadExpenses()
    }
    
    func loadExpenses() {
        isLoading = true
        expenses = dataService.loadExpenses()
        isLoading = false
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            saveExpenses()
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses()
    }
    
    func deleteExpenses(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        saveExpenses()
    }
    
    private func saveExpenses() {
        dataService.saveExpenses(expenses)
    }
    
    func totalExpenses(for period: Budget.BudgetPeriod) -> Double {
        return analyticsService.totalExpenses(for: expenses, in: period)
    }
    
    func expensesByCategory(for period: Budget.BudgetPeriod) -> [Expense.ExpenseCategory: Double] {
        return analyticsService.expensesByCategory(for: expenses, in: period)
    }
    
    func recentExpenses(limit: Int = 5) -> [Expense] {
        return Array(expenses.sorted { $0.date > $1.date }.prefix(limit))
    }
}

