//
//  NeumorphicStyleModifiers.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

// MARK: - Color Theme
struct AppColors {
    static let background = Color(hex: "000000")
    static let primary = Color(hex: "fbd600")
    static let secondary = Color(hex: "ffffff")
    static let cardBackground = Color(hex: "1a1a1a")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Neumorphic Style
struct NeumorphicStyle: ViewModifier {
    var isPressed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: Color.white.opacity(isPressed ? 0.05 : 0.1), radius: isPressed ? 4 : 8, x: isPressed ? -2 : -5, y: isPressed ? -2 : -5)
                    .shadow(color: Color.black.opacity(isPressed ? 0.3 : 0.5), radius: isPressed ? 4 : 8, x: isPressed ? 2 : 5, y: isPressed ? 2 : 5)
            )
    }
}

struct NeumorphicButtonStyle: ViewModifier {
    var isPressed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.primary)
                    .shadow(color: Color.white.opacity(isPressed ? 0.05 : 0.2), radius: isPressed ? 2 : 6, x: isPressed ? -1 : -3, y: isPressed ? -1 : -3)
                    .shadow(color: Color.black.opacity(isPressed ? 0.2 : 0.4), radius: isPressed ? 2 : 6, x: isPressed ? 1 : 3, y: isPressed ? 1 : 3)
            )
    }
}

extension View {
    func neumorphic(isPressed: Bool = false) -> some View {
        modifier(NeumorphicStyle(isPressed: isPressed))
    }
    
    func neumorphicButton(isPressed: Bool = false) -> some View {
        modifier(NeumorphicButtonStyle(isPressed: isPressed))
    }
}

// MARK: - Custom Card View
struct NeumorphicCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .neumorphic()
    }
}

