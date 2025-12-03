//
//  ContentView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var expenseVM = ExpenseViewModel()
    @StateObject private var investmentVM = InvestmentViewModel()
    @StateObject private var budgetVM = BudgetViewModel()
    
    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView()
        } else {
            MainTabView(expenseVM: expenseVM, investmentVM: investmentVM, budgetVM: budgetVM)
        }
    }
}

struct MainTabView: View {
    @ObservedObject var expenseVM: ExpenseViewModel
    @ObservedObject var investmentVM: InvestmentViewModel
    @ObservedObject var budgetVM: BudgetViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(expenseVM)
                .environmentObject(investmentVM)
                .environmentObject(budgetVM)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            NavigationView {
                ExpenseListView(viewModel: expenseVM)
            }
            .tabItem {
                Label("Expenses", systemImage: "dollarsign.circle.fill")
            }
            
            NavigationView {
                InvestmentListView(viewModel: investmentVM)
            }
            .tabItem {
                Label("Investments", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            NavigationView {
                SavingsGoalsView(viewModel: budgetVM)
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(AppColors.primary)
    }
}

#Preview {
    ContentView()
}
