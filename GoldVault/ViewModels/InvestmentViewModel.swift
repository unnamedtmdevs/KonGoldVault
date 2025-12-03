//
//  InvestmentViewModel.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation
import Combine

class InvestmentViewModel: ObservableObject {
    @Published var investments: [Investment] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = DataService.shared
    private let analyticsService = AnalyticsService.shared
    
    init() {
        loadInvestments()
    }
    
    func loadInvestments() {
        isLoading = true
        investments = dataService.loadInvestments()
        isLoading = false
    }
    
    func addInvestment(_ investment: Investment) {
        investments.append(investment)
        saveInvestments()
    }
    
    func updateInvestment(_ investment: Investment) {
        if let index = investments.firstIndex(where: { $0.id == investment.id }) {
            investments[index] = investment
            saveInvestments()
        }
    }
    
    func deleteInvestment(_ investment: Investment) {
        investments.removeAll { $0.id == investment.id }
        saveInvestments()
    }
    
    func deleteInvestments(at offsets: IndexSet) {
        investments.remove(atOffsets: offsets)
        saveInvestments()
    }
    
    private func saveInvestments() {
        dataService.saveInvestments(investments)
    }
    
    var totalValue: Double {
        return analyticsService.totalInvestmentValue(investments)
    }
    
    var totalProfit: Double {
        return analyticsService.totalInvestmentProfit(investments)
    }
    
    var averageROI: Double {
        return analyticsService.averageROI(investments)
    }
}

