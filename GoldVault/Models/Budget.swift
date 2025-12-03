//
//  Budget.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation

struct Budget: Identifiable, Codable {
    var id: UUID = UUID()
    var category: Expense.ExpenseCategory
    var limit: Double
    var period: BudgetPeriod
    var alertThreshold: Double // Percentage (0-100) at which to alert
    
    enum BudgetPeriod: String, Codable, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
}

struct SavingsGoal: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date
    var icon: String
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min((currentAmount / targetAmount) * 100, 100)
    }
    
    var isCompleted: Bool {
        return currentAmount >= targetAmount
    }
}

