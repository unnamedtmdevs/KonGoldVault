//
//  DataService.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation
import Combine

class DataService {
    static let shared = DataService()
    
    private let expensesKey = "expenses"
    private let investmentsKey = "investments"
    private let budgetsKey = "budgets"
    private let savingsGoalsKey = "savingsGoals"
    
    private init() {}
    
    // MARK: - Expenses
    func saveExpenses(_ expenses: [Expense]) {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: expensesKey)
        }
    }
    
    func loadExpenses() -> [Expense] {
        guard let data = UserDefaults.standard.data(forKey: expensesKey),
              let expenses = try? JSONDecoder().decode([Expense].self, from: data) else {
            return []
        }
        return expenses
    }
    
    // MARK: - Investments
    func saveInvestments(_ investments: [Investment]) {
        if let encoded = try? JSONEncoder().encode(investments) {
            UserDefaults.standard.set(encoded, forKey: investmentsKey)
        }
    }
    
    func loadInvestments() -> [Investment] {
        guard let data = UserDefaults.standard.data(forKey: investmentsKey),
              let investments = try? JSONDecoder().decode([Investment].self, from: data) else {
            return []
        }
        return investments
    }
    
    // MARK: - Budgets
    func saveBudgets(_ budgets: [Budget]) {
        if let encoded = try? JSONEncoder().encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: budgetsKey)
        }
    }
    
    func loadBudgets() -> [Budget] {
        guard let data = UserDefaults.standard.data(forKey: budgetsKey),
              let budgets = try? JSONDecoder().decode([Budget].self, from: data) else {
            return []
        }
        return budgets
    }
    
    // MARK: - Savings Goals
    func saveSavingsGoals(_ goals: [SavingsGoal]) {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: savingsGoalsKey)
        }
    }
    
    func loadSavingsGoals() -> [SavingsGoal] {
        guard let data = UserDefaults.standard.data(forKey: savingsGoalsKey),
              let goals = try? JSONDecoder().decode([SavingsGoal].self, from: data) else {
            return []
        }
        return goals
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: expensesKey)
        UserDefaults.standard.removeObject(forKey: investmentsKey)
        UserDefaults.standard.removeObject(forKey: budgetsKey)
        UserDefaults.standard.removeObject(forKey: savingsGoalsKey)
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "initialBudget")
    }
}

