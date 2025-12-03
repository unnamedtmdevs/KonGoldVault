//
//  DashboardView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var expenseVM = ExpenseViewModel()
    @StateObject private var investmentVM = InvestmentViewModel()
    @StateObject private var budgetVM = BudgetViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Financial Overview Cards
                        financialOverviewSection
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Recent Expenses
                        recentExpensesSection
                        
                        // Savings Goals
                        savingsGoalsSection
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("KanGold Vault")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.primary)
            
            Text("Your Financial Overview")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var financialOverviewSection: some View {
        VStack(spacing: 15) {
            // Total Balance Card
            NeumorphicCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Portfolio Value")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                    
                    Text("$\(investmentVM.totalValue, specifier: "%.2f")")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(AppColors.primary)
                    
                    HStack {
                        Image(systemName: investmentVM.totalProfit >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(investmentVM.totalProfit >= 0 ? "+" : "")\(investmentVM.totalProfit, specifier: "%.2f")")
                        Text("(\(investmentVM.averageROI, specifier: "%.1f")%)")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(investmentVM.totalProfit >= 0 ? .green : .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Monthly Expenses Card
            NeumorphicCard {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("This Month")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.secondary.opacity(0.7))
                        
                        Text("$\(expenseVM.totalExpenses(for: .monthly), specifier: "%.2f")")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primary.opacity(0.5))
                }
            }
        }
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: 15) {
            QuickStatCard(
                title: "Today",
                amount: expenseVM.totalExpenses(for: .daily),
                icon: "calendar"
            )
            
            QuickStatCard(
                title: "This Week",
                amount: expenseVM.totalExpenses(for: .weekly),
                icon: "calendar.badge.clock"
            )
        }
    }
    
    private var recentExpensesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Expenses")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.secondary)
                
                Spacer()
                
                NavigationLink(destination: ExpenseListView(viewModel: expenseVM)) {
                    Text("See All")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.primary)
                }
            }
            
            if expenseVM.recentExpenses().isEmpty {
                NeumorphicCard {
                    VStack(spacing: 10) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.secondary.opacity(0.3))
                        
                        Text("No expenses yet")
                            .foregroundColor(AppColors.secondary.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            } else {
                ForEach(expenseVM.recentExpenses()) { expense in
                    ExpenseRowView(expense: expense)
                }
            }
        }
    }
    
    private var savingsGoalsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Savings Goals")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.secondary)
                
                Spacer()
                
                NavigationLink(destination: SavingsGoalsView(viewModel: budgetVM)) {
                    Text("See All")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.primary)
                }
            }
            
            if budgetVM.savingsGoals.isEmpty {
                NeumorphicCard {
                    VStack(spacing: 10) {
                        Image(systemName: "target")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.secondary.opacity(0.3))
                        
                        Text("No savings goals yet")
                            .foregroundColor(AppColors.secondary.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            } else {
                ForEach(budgetVM.savingsGoals.prefix(3)) { goal in
                    SavingsGoalRowView(goal: goal)
                }
            }
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let amount: Double
    let icon: String
    
    var body: some View {
        NeumorphicCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(AppColors.primary)
                    Spacer()
                }
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.secondary.opacity(0.7))
                
                Text("$\(amount, specifier: "%.2f")")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        NeumorphicCard {
            HStack {
                Image(systemName: expense.category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(expense.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.secondary)
                    
                    Text(expense.category.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondary.opacity(0.6))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("-$\(expense.amount, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Text(expense.date, style: .date)
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.secondary.opacity(0.6))
                }
            }
        }
    }
}

struct SavingsGoalRowView: View {
    let goal: SavingsGoal
    
    var body: some View {
        NeumorphicCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: goal.icon)
                        .foregroundColor(AppColors.primary)
                    
                    Text(goal.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(goal.progress))%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
                
                ProgressView(value: goal.progress, total: 100)
                    .tint(AppColors.primary)
                
                HStack {
                    Text("$\(goal.currentAmount, specifier: "%.2f")")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                    
                    Spacer()
                    
                    Text("of $\(goal.targetAmount, specifier: "%.2f")")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                }
            }
        }
    }
}

