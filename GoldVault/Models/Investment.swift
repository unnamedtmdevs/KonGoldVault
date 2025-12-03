//
//  Investment.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation

struct Investment: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var symbol: String
    var amount: Double
    var purchasePrice: Double
    var currentPrice: Double
    var quantity: Double
    var type: InvestmentType
    var purchaseDate: Date
    
    var totalValue: Double {
        return quantity * currentPrice
    }
    
    var totalInvested: Double {
        return quantity * purchasePrice
    }
    
    var profit: Double {
        return totalValue - totalInvested
    }
    
    var profitPercentage: Double {
        guard totalInvested > 0 else { return 0 }
        return (profit / totalInvested) * 100
    }
    
    enum InvestmentType: String, Codable, CaseIterable {
        case stocks = "Stocks"
        case crypto = "Cryptocurrency"
        case bonds = "Bonds"
        case realEstate = "Real Estate"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .stocks: return "chart.line.uptrend.xyaxis"
            case .crypto: return "bitcoinsign.circle.fill"
            case .bonds: return "doc.text.fill"
            case .realEstate: return "house.fill"
            case .other: return "dollarsign.circle.fill"
            }
        }
    }
}

