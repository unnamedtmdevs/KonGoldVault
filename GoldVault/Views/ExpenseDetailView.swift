//
//  ExpenseDetailView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showingAddExpense = false
    @State private var selectedPeriod: Budget.BudgetPeriod = .monthly
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack {
                // Period Selector
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(Budget.BudgetPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Total for period
                NeumorphicCard {
                    HStack {
                        Text("Total \(selectedPeriod.rawValue)")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.secondary)
                        
                        Spacer()
                        
                        Text("$\(viewModel.totalExpenses(for: selectedPeriod), specifier: "%.2f")")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.horizontal)
                
                // Expenses List
                List {
                    ForEach(viewModel.expenses.sorted { $0.date > $1.date }) { expense in
                        NavigationLink(destination: AddEditExpenseView(viewModel: viewModel, expense: expense)) {
                            ExpenseRowView(expense: expense)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                    .onDelete(perform: viewModel.deleteExpenses)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
        }
        .navigationTitle("Expenses")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddEditExpenseView(viewModel: viewModel)
        }
    }
}

struct AddEditExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var expense: Expense?
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category: Expense.ExpenseCategory = .other
    @State private var date = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Title")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                TextField("Expense title", text: $title)
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.secondary)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Amount")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                HStack {
                                    Text("$")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    TextField("0.00", text: $amount)
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.secondary)
                                        .keyboardType(.decimalPad)
                                        .padding()
                                        .background(AppColors.cardBackground)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Category")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                Picker("Category", selection: $category) {
                                    ForEach(Expense.ExpenseCategory.allCases, id: \.self) { cat in
                                        HStack {
                                            Image(systemName: cat.icon)
                                            Text(cat.rawValue)
                                        }
                                        .tag(cat)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Date")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Notes (Optional)")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                TextEditor(text: $notes)
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.secondary)
                                    .frame(height: 100)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button(action: saveExpense) {
                            Text(expense == nil ? "Add Expense" : "Update Expense")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.background)
                                .frame(maxWidth: .infinity)
                                .neumorphicButton()
                        }
                        .disabled(title.isEmpty || amount.isEmpty || Double(amount) == nil)
                        .opacity(title.isEmpty || amount.isEmpty || Double(amount) == nil ? 0.5 : 1.0)
                    }
                    .padding()
                }
            }
            .navigationTitle(expense == nil ? "Add Expense" : "Edit Expense")
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
            if let expense = expense {
                title = expense.title
                amount = String(expense.amount)
                category = expense.category
                date = expense.date
                notes = expense.notes
            }
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        if let existingExpense = expense {
            let updated = Expense(
                id: existingExpense.id,
                title: title,
                amount: amountValue,
                category: category,
                date: date,
                notes: notes
            )
            viewModel.updateExpense(updated)
        } else {
            let newExpense = Expense(
                title: title,
                amount: amountValue,
                category: category,
                date: date,
                notes: notes
            )
            viewModel.addExpense(newExpense)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

