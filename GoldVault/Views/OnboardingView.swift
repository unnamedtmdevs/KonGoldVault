//
//  OnboardingView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("initialBudget") private var initialBudget: Double = 0
    
    @State private var currentPage = 0
    @State private var budgetInput = ""
    @State private var selectedCategories: Set<Expense.ExpenseCategory> = []
    @State private var savingsGoalTitle = ""
    @State private var savingsGoalAmount = ""
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Welcome Screen
                welcomeScreen
                    .tag(0)
                
                // Budget Setup
                budgetSetupScreen
                    .tag(1)
                
                // Category Selection
                categorySelectionScreen
                    .tag(2)
                
                // Financial Goals
                financialGoalsScreen
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
    
    private var welcomeScreen: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(AppColors.primary)
            
            Text("Welcome to KanGold Vault")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.secondary)
            
            NeumorphicCard {
                VStack(alignment: .leading, spacing: 15) {
                    FeatureRow(icon: "chart.bar.fill", text: "Track expenses in real-time")
                    FeatureRow(icon: "dollarsign.circle.fill", text: "Manage investments efficiently")
                    FeatureRow(icon: "target", text: "Set and achieve financial goals")
                    FeatureRow(icon: "bell.fill", text: "Smart budget alerts")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    currentPage = 1
                }
            }) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.background)
                    .frame(maxWidth: .infinity)
                    .neumorphicButton()
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private var budgetSetupScreen: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Set Your Monthly Budget")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.secondary)
            
            Text("This helps us track your spending habits")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondary.opacity(0.7))
            
            NeumorphicCard {
                VStack(spacing: 15) {
                    HStack {
                        Text("$")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.primary)
                        
                        TextField("Enter amount", text: $budgetInput)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(AppColors.secondary)
                            .keyboardType(.decimalPad)
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                if let budget = Double(budgetInput), budget > 0 {
                    initialBudget = budget
                    withAnimation {
                        currentPage = 2
                    }
                }
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.background)
                    .frame(maxWidth: .infinity)
                    .neumorphicButton()
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
            .disabled(budgetInput.isEmpty || Double(budgetInput) == nil)
            .opacity(budgetInput.isEmpty || Double(budgetInput) == nil ? 0.5 : 1.0)
        }
    }
    
    private var categorySelectionScreen: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Select Your Expense Categories")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.secondary)
                .multilineTextAlignment(.center)
            
            Text("Choose categories you want to track")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondary.opacity(0.7))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(Expense.ExpenseCategory.allCases, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        isSelected: selectedCategories.contains(category)
                    )
                    .onTapGesture {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    currentPage = 3
                }
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.background)
                    .frame(maxWidth: .infinity)
                    .neumorphicButton()
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private var financialGoalsScreen: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Set Your First Goal")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.secondary)
            
            Text("Optional - You can add more later")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondary.opacity(0.7))
            
            NeumorphicCard {
                VStack(spacing: 20) {
                    TextField("Goal name (e.g., Emergency Fund)", text: $savingsGoalTitle)
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.secondary)
                        .padding()
                    
                    HStack {
                        Text("$")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppColors.primary)
                        
                        TextField("Target amount", text: $savingsGoalAmount)
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.secondary)
                            .keyboardType(.decimalPad)
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: {
                    completeOnboarding()
                }) {
                    Text("Start Using KanGold Vault")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.background)
                        .frame(maxWidth: .infinity)
                        .neumorphicButton()
                }
                
                Button(action: {
                    completeOnboarding()
                }) {
                    Text("Skip for now")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private func completeOnboarding() {
        // Save initial setup data
        if !savingsGoalTitle.isEmpty, let amount = Double(savingsGoalAmount), amount > 0 {
            let goal = SavingsGoal(
                title: savingsGoalTitle,
                targetAmount: amount,
                currentAmount: 0,
                deadline: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(),
                icon: "target"
            )
            var goals = DataService.shared.loadSavingsGoals()
            goals.append(goal)
            DataService.shared.saveSavingsGoals(goals)
        }
        
        // Create budgets for selected categories
        var budgets: [Budget] = []
        for category in selectedCategories {
            let budget = Budget(
                category: category,
                limit: initialBudget / Double(max(selectedCategories.count, 1)),
                period: .monthly,
                alertThreshold: 80
            )
            budgets.append(budget)
        }
        DataService.shared.saveBudgets(budgets)
        
        hasCompletedOnboarding = true
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(AppColors.primary)
                .frame(width: 30)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondary)
            
            Spacer()
        }
    }
}

struct CategoryCard: View {
    let category: Expense.ExpenseCategory
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: category.icon)
                .font(.system(size: 30))
                .foregroundColor(isSelected ? AppColors.background : AppColors.primary)
            
            Text(category.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? AppColors.background : AppColors.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? AppColors.primary : AppColors.cardBackground)
                .shadow(color: Color.white.opacity(0.1), radius: 8, x: -5, y: -5)
                .shadow(color: Color.black.opacity(0.5), radius: 8, x: 5, y: 5)
        )
    }
}

