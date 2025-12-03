//
//  BudgetViewModel.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation
import Combine

class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    @Published var savingsGoals: [SavingsGoal] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = DataService.shared
    private let analyticsService = AnalyticsService.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        budgets = dataService.loadBudgets()
        savingsGoals = dataService.loadSavingsGoals()
        isLoading = false
    }
    
    // MARK: - Budgets
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveBudgets()
    }
    
    func updateBudget(_ budget: Budget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
            saveBudgets()
        }
    }
    
    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        saveBudgets()
    }
    
    func deleteBudgets(at offsets: IndexSet) {
        budgets.remove(atOffsets: offsets)
        saveBudgets()
    }
    
    private func saveBudgets() {
        dataService.saveBudgets(budgets)
    }
    
    func budgetUsage(for budget: Budget, expenses: [Expense]) -> Double {
        return analyticsService.budgetUsage(for: budget, expenses: expenses)
    }
    
    func isOverBudget(for budget: Budget, expenses: [Expense]) -> Bool {
        return analyticsService.isOverBudget(for: budget, expenses: expenses)
    }
    
    // MARK: - Savings Goals
    func addSavingsGoal(_ goal: SavingsGoal) {
        savingsGoals.append(goal)
        saveSavingsGoals()
    }
    
    func updateSavingsGoal(_ goal: SavingsGoal) {
        if let index = savingsGoals.firstIndex(where: { $0.id == goal.id }) {
            savingsGoals[index] = goal
            saveSavingsGoals()
        }
    }
    
    func deleteSavingsGoal(_ goal: SavingsGoal) {
        savingsGoals.removeAll { $0.id == goal.id }
        saveSavingsGoals()
    }
    
    func deleteSavingsGoals(at offsets: IndexSet) {
        savingsGoals.remove(atOffsets: offsets)
        saveSavingsGoals()
    }
    
    func addToSavingsGoal(_ goal: SavingsGoal, amount: Double) {
        if let index = savingsGoals.firstIndex(where: { $0.id == goal.id }) {
            savingsGoals[index].currentAmount += amount
            saveSavingsGoals()
        }
    }
    
    private func saveSavingsGoals() {
        dataService.saveSavingsGoals(savingsGoals)
    }
}

