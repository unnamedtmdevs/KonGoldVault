//
//  Expense.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import Foundation

struct Expense: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var category: ExpenseCategory
    var date: Date
    var notes: String
    
    enum ExpenseCategory: String, Codable, CaseIterable {
        case food = "Food"
        case transportation = "Transportation"
        case entertainment = "Entertainment"
        case shopping = "Shopping"
        case health = "Health"
        case utilities = "Utilities"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .food: return "fork.knife"
            case .transportation: return "car.fill"
            case .entertainment: return "tv.fill"
            case .shopping: return "cart.fill"
            case .health: return "cross.fill"
            case .utilities: return "lightbulb.fill"
            case .other: return "ellipsis.circle.fill"
            }
        }
    }
}

