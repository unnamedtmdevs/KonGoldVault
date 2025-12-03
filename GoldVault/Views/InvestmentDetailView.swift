//
//  InvestmentDetailView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct InvestmentListView: View {
    @ObservedObject var viewModel: InvestmentViewModel
    @State private var showingAddInvestment = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack {
                // Portfolio Summary
                NeumorphicCard {
                    VStack(spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Value")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                Text("$\(viewModel.totalValue, specifier: "%.2f")")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(AppColors.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Profit/Loss")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                Text("\(viewModel.totalProfit >= 0 ? "+" : "")$\(viewModel.totalProfit, specifier: "%.2f")")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(viewModel.totalProfit >= 0 ? .green : .red)
                            }
                        }
                        
                        HStack {
                            Text("Average ROI:")
                                .foregroundColor(AppColors.secondary.opacity(0.7))
                            
                            Text("\(viewModel.averageROI, specifier: "%.2f")%")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(viewModel.averageROI >= 0 ? .green : .red)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                
                // Investments List
                List {
                    ForEach(viewModel.investments) { investment in
                        NavigationLink(destination: AddEditInvestmentView(viewModel: viewModel, investment: investment)) {
                            InvestmentRowView(investment: investment)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                    .onDelete(perform: viewModel.deleteInvestments)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
        }
        .navigationTitle("Investments")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddInvestment = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddInvestment) {
            AddEditInvestmentView(viewModel: viewModel)
        }
    }
}

struct InvestmentRowView: View {
    let investment: Investment
    
    var body: some View {
        NeumorphicCard {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: investment.type.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(investment.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.secondary)
                        
                        Text(investment.symbol)
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.secondary.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(investment.totalValue, specifier: "%.2f")")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: investment.profit >= 0 ? "arrow.up.right" : "arrow.down.right")
                            Text("\(investment.profitPercentage, specifier: "%.1f")%")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(investment.profit >= 0 ? .green : .red)
                    }
                }
                
                Divider()
                    .background(AppColors.secondary.opacity(0.2))
                
                HStack {
                    Text("Qty: \(investment.quantity, specifier: "%.2f")")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                    
                    Spacer()
                    
                    Text("Current: $\(investment.currentPrice, specifier: "%.2f")")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondary.opacity(0.7))
                }
            }
        }
    }
}

struct AddEditInvestmentView: View {
    @ObservedObject var viewModel: InvestmentViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var investment: Investment?
    
    @State private var name = ""
    @State private var symbol = ""
    @State private var quantity = ""
    @State private var purchasePrice = ""
    @State private var currentPrice = ""
    @State private var type: Investment.InvestmentType = .stocks
    @State private var purchaseDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Name")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                TextField("Investment name", text: $name)
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.secondary)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Symbol/Ticker")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                TextField("e.g., AAPL, BTC", text: $symbol)
                                    .font(.system(size: 18))
                                    .foregroundColor(AppColors.secondary)
                                    .textInputAutocapitalization(.characters)
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Type")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                Picker("Type", selection: $type) {
                                    ForEach(Investment.InvestmentType.allCases, id: \.self) { investmentType in
                                        HStack {
                                            Image(systemName: investmentType.icon)
                                            Text(investmentType.rawValue)
                                        }
                                        .tag(investmentType)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(8)
                            }
                        }
                        
                        HStack(spacing: 15) {
                            NeumorphicCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Quantity")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                    
                                    TextField("0.00", text: $quantity)
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.secondary)
                                        .keyboardType(.decimalPad)
                                }
                            }
                            
                            NeumorphicCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Purchase Price")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                    
                                    HStack {
                                        Text("$")
                                            .foregroundColor(AppColors.primary)
                                        TextField("0.00", text: $purchasePrice)
                                            .font(.system(size: 16))
                                            .foregroundColor(AppColors.secondary)
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                        }
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Current Price")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                HStack {
                                    Text("$")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppColors.primary)
                                    
                                    TextField("0.00", text: $currentPrice)
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
                                Text("Purchase Date")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                                
                                DatePicker("", selection: $purchaseDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button(action: saveInvestment) {
                            Text(investment == nil ? "Add Investment" : "Update Investment")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.background)
                                .frame(maxWidth: .infinity)
                                .neumorphicButton()
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)
                    }
                    .padding()
                }
            }
            .navigationTitle(investment == nil ? "Add Investment" : "Edit Investment")
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
            if let investment = investment {
                name = investment.name
                symbol = investment.symbol
                quantity = String(investment.quantity)
                purchasePrice = String(investment.purchasePrice)
                currentPrice = String(investment.currentPrice)
                type = investment.type
                purchaseDate = investment.purchaseDate
            }
        }
    }
    
    private var isFormValid: Bool {
        return !name.isEmpty &&
            !symbol.isEmpty &&
            Double(quantity) != nil &&
            Double(purchasePrice) != nil &&
            Double(currentPrice) != nil
    }
    
    private func saveInvestment() {
        guard let quantityValue = Double(quantity),
              let purchasePriceValue = Double(purchasePrice),
              let currentPriceValue = Double(currentPrice) else { return }
        
        if let existingInvestment = investment {
            let updated = Investment(
                id: existingInvestment.id,
                name: name,
                symbol: symbol,
                amount: quantityValue * currentPriceValue,
                purchasePrice: purchasePriceValue,
                currentPrice: currentPriceValue,
                quantity: quantityValue,
                type: type,
                purchaseDate: purchaseDate
            )
            viewModel.updateInvestment(updated)
        } else {
            let newInvestment = Investment(
                name: name,
                symbol: symbol,
                amount: quantityValue * currentPriceValue,
                purchasePrice: purchasePriceValue,
                currentPrice: currentPriceValue,
                quantity: quantityValue,
                type: type,
                purchaseDate: purchaseDate
            )
            viewModel.addInvestment(newInvestment)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

