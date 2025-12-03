//
//  AnalyticsService.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation

class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    // MARK: - Expense Analytics
    func totalExpenses(for expenses: [Expense], in period: Budget.BudgetPeriod) -> Double {
        let filteredExpenses = filterExpenses(expenses, for: period)
        return filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    func expensesByCategory(for expenses: [Expense], in period: Budget.BudgetPeriod) -> [Expense.ExpenseCategory: Double] {
        let filteredExpenses = filterExpenses(expenses, for: period)
        var categoryTotals: [Expense.ExpenseCategory: Double] = [:]
        
        for expense in filteredExpenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        return categoryTotals
    }
    
    func filterExpenses(_ expenses: [Expense], for period: Budget.BudgetPeriod) -> [Expense] {
        let now = Date()
        let calendar = Calendar.current
        
        return expenses.filter { expense in
            switch period {
            case .daily:
                return calendar.isDateInToday(expense.date)
            case .weekly:
                return calendar.isDate(expense.date, equalTo: now, toGranularity: .weekOfYear)
            case .monthly:
                return calendar.isDate(expense.date, equalTo: now, toGranularity: .month)
            case .yearly:
                return calendar.isDate(expense.date, equalTo: now, toGranularity: .year)
            }
        }
    }
    
    // MARK: - Budget Analytics
    func budgetUsage(for budget: Budget, expenses: [Expense]) -> Double {
        let categoryExpenses = filterExpenses(expenses, for: budget.period)
            .filter { $0.category == budget.category }
        let total = categoryExpenses.reduce(0) { $0 + $1.amount }
        
        guard budget.limit > 0 else { return 0 }
        return min((total / budget.limit) * 100, 100)
    }
    
    func isOverBudget(for budget: Budget, expenses: [Expense]) -> Bool {
        return budgetUsage(for: budget, expenses: expenses) >= 100
    }
    
    func shouldAlert(for budget: Budget, expenses: [Expense]) -> Bool {
        return budgetUsage(for: budget, expenses: expenses) >= budget.alertThreshold
    }
    
    // MARK: - Investment Analytics
    func totalInvestmentValue(_ investments: [Investment]) -> Double {
        return investments.reduce(0) { $0 + $1.totalValue }
    }
    
    func totalInvestmentProfit(_ investments: [Investment]) -> Double {
        return investments.reduce(0) { $0 + $1.profit }
    }
    
    func averageROI(_ investments: [Investment]) -> Double {
        guard !investments.isEmpty else { return 0 }
        let totalROI = investments.reduce(0) { $0 + $1.profitPercentage }
        return totalROI / Double(investments.count)
    }
}

