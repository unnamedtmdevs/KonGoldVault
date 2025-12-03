//
//  SavingsGoalsView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct SavingsGoalsView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @State private var showingAddGoal = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack {
                if viewModel.savingsGoals.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.secondary.opacity(0.3))
                        
                        Text("No savings goals yet")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.secondary.opacity(0.7))
                        
                        Button(action: {
                            showingAddGoal = true
                        }) {
                            Text("Create Your First Goal")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.background)
                                .padding()
                                .neumorphicButton()
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.savingsGoals) { goal in
                            NavigationLink(destination: SavingsGoalDetailView(viewModel: viewModel, goal: goal)) {
                                SavingsGoalRowView(goal: goal)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                        .onDelete(perform: viewModel.deleteSavingsGoals)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
            }
        }
        .navigationTitle("Savings Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddGoal = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddEditSavingsGoalView(viewModel: viewModel)
        }
    }
}

struct SavingsGoalDetailView: View {
    @ObservedObject var viewModel: BudgetViewModel
    let goal: SavingsGoal
    @State private var showingAddAmount = false
    @State private var amountToAdd = ""
    @State private var showingEdit = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Goal Header
                    NeumorphicCard {
                        VStack(spacing: 15) {
                            Image(systemName: goal.icon)
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.primary)
                            
                            Text(goal.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.secondary)
                            
                            Text("\(Int(goal.progress))% Complete")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.secondary.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Progress Card
                    NeumorphicCard {
                        VStack(spacing: 15) {
                            ProgressView(value: goal.progress, total: 100)
                                .tint(AppColors.primary)
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Current")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                    
                                    Text("$\(goal.currentAmount, specifier: "%.2f")")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.primary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Target")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                    
                                    Text("$\(goal.targetAmount, specifier: "%.2f")")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.secondary)
                                }
                            }
                            
                            Divider()
                                .background(AppColors.secondary.opacity(0.2))
                            
                            HStack {
                                Text("Remaining:")
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                Spacer()
                                
                                Text("$\(max(goal.targetAmount - goal.currentAmount, 0), specifier: "%.2f")")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.secondary)
                            }
                        }
                    }
                    
                    // Deadline Card
                    NeumorphicCard {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(AppColors.primary)
                            
                            Text("Target Date:")
                                .foregroundColor(AppColors.secondary)
                            
                            Spacer()
                            
                            Text(goal.deadline, style: .date)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.secondary)
                        }
                    }
                    
                    // Add Money Button
                    if !goal.isCompleted {
                        Button(action: {
                            showingAddAmount = true
                        }) {
                            Text("Add Money")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.background)
                                .frame(maxWidth: .infinity)
                                .neumorphicButton()
                        }
                    } else {
                        NeumorphicCard {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 24))
                                
                                Text("Goal Completed!")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingEdit = true
                }) {
                    Text("Edit")
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddAmount) {
            AddMoneyToGoalView(viewModel: viewModel, goal: goal, amountToAdd: $amountToAdd)
        }
        .sheet(isPresented: $showingEdit) {
            AddEditSavingsGoalView(viewModel: viewModel, goal: goal)
        }
    }
}

struct AddMoneyToGoalView: View {
    @ObservedObject var viewModel: BudgetViewModel
    let goal: SavingsGoal
    @Binding var amountToAdd: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Add to \(goal.title)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppColors.secondary)
                    
                    NeumorphicCard {
                        VStack(spacing: 15) {
                            HStack {
                                Text("$")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                                
                                TextField("0.00", text: $amountToAdd)
                                    .font(.system(size: 32))
                                    .foregroundColor(AppColors.secondary)
                                    .keyboardType(.decimalPad)
                            }
                            .padding()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if let amount = Double(amountToAdd), amount > 0 {
                            viewModel.addToSavingsGoal(goal, amount: amount)
                            amountToAdd = ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Money")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.background)
                            .frame(maxWidth: .infinity)
                            .neumorphicButton()
                    }
                    .disabled(amountToAdd.isEmpty || Double(amountToAdd) == nil)
                    .opacity(amountToAdd.isEmpty || Double(amountToAdd) == nil ? 0.5 : 1.0)
                    .padding(.bottom, 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.secondary)
                }
            }
        }
    }
}

struct AddEditSavingsGoalView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var goal: SavingsGoal?
    
    @State private var title = ""
    @State private var targetAmount = ""
    @State private var currentAmount = ""
    @State private var deadline = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var selectedIcon = "target"
    
    let availableIcons = ["target", "house.fill", "car.fill", "airplane", "briefcase.fill", "gift.fill", "star.fill"]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Goal Title")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                TextField("e.g., Emergency Fund", text: $title)
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.secondary)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Target Amount")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                HStack {
                                    Text("$")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    TextField("0.00", text: $targetAmount)
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.secondary)
                                        .keyboardType(.decimalPad)
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        if goal != nil {
                            NeumorphicCard {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Current Amount")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                    
                                    HStack {
                                        Text("$")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(AppColors.primary)
                                        
                                        TextField("0.00", text: $currentAmount)
                                            .font(.system(size: 20))
                                            .foregroundColor(AppColors.secondary)
                                            .keyboardType(.decimalPad)
                                            .padding()
                                            .background(AppColors.cardBackground)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Target Date")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                DatePicker("", selection: $deadline, in: Date()..., displayedComponents: .date)
                                    .labelsHidden()
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Icon")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                                    ForEach(availableIcons, id: \.self) { icon in
                                        Button(action: {
                                            selectedIcon = icon
                                        }) {
                                            Image(systemName: icon)
                                                .font(.system(size: 24))
                                                .foregroundColor(selectedIcon == icon ? AppColors.background : AppColors.primary)
                                                .frame(width: 60, height: 60)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(selectedIcon == icon ? AppColors.primary : AppColors.cardBackground)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button(action: saveGoal) {
                            Text(goal == nil ? "Create Goal" : "Update Goal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.background)
                                .frame(maxWidth: .infinity)
                                .neumorphicButton()
                        }
                        .disabled(title.isEmpty || targetAmount.isEmpty || Double(targetAmount) == nil)
                        .opacity(title.isEmpty || targetAmount.isEmpty || Double(targetAmount) == nil ? 0.5 : 1.0)
                    }
                    .padding()
                }
            }
            .navigationTitle(goal == nil ? "New Savings Goal" : "Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.secondary)
                }
            }
        }
        .onAppear {
            if let goal = goal {
                title = goal.title
                targetAmount = String(goal.targetAmount)
                currentAmount = String(goal.currentAmount)
                deadline = goal.deadline
                selectedIcon = goal.icon
            }
        }
    }
    
    private func saveGoal() {
        guard let targetAmountValue = Double(targetAmount) else { return }
        let currentAmountValue = Double(currentAmount) ?? 0
        
        if let existingGoal = goal {
            let updated = SavingsGoal(
                id: existingGoal.id,
                title: title,
                targetAmount: targetAmountValue,
                currentAmount: currentAmountValue,
                deadline: deadline,
                icon: selectedIcon
            )
            viewModel.updateSavingsGoal(updated)
        } else {
            let newGoal = SavingsGoal(
                title: title,
                targetAmount: targetAmountValue,
                currentAmount: 0,
                deadline: deadline,
                icon: selectedIcon
            )
            viewModel.addSavingsGoal(newGoal)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

