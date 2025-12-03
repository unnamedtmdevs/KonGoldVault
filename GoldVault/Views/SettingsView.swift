//
//  SettingsView.swift
//  GoldVault
//
//  Created by Simon Bakhanets on 03.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showingDeleteAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // App Info
                        NeumorphicCard {
                            VStack(spacing: 15) {
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppColors.primary)
                                
                                Text("KanGold Vault")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.secondary)
                                
                                Text("Version 1.0.0")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        
                        // Settings Options
                        VStack(spacing: 15) {
                            SettingsRow(
                                icon: "bell.fill",
                                title: "Notifications",
                                subtitle: "Manage budget alerts"
                            )
                            
                            SettingsRow(
                                icon: "lock.fill",
                                title: "Privacy & Security",
                                subtitle: "Your data is stored locally"
                            )
                            
                            SettingsRow(
                                icon: "info.circle.fill",
                                title: "About",
                                subtitle: "Learn more about KanGold Vault"
                            )
                            .onTapGesture {
                                showingAbout = true
                            }
                            
                            SettingsRow(
                                icon: "arrow.clockwise",
                                title: "Reset Onboarding",
                                subtitle: "Go through the setup again"
                            )
                            .onTapGesture {
                                hasCompletedOnboarding = false
                            }
                        }
                        
                        // Data Management
                        VStack(spacing: 15) {
                            Text("Data Management")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            NeumorphicCard {
                                VStack(spacing: 15) {
                                    HStack {
                                        Image(systemName: "externaldrive.fill")
                                            .foregroundColor(AppColors.primary)
                                            .frame(width: 30)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Local Storage")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(AppColors.secondary)
                                            
                                            Text("All data stored on device")
                                                .font(.system(size: 12))
                                                .foregroundColor(AppColors.secondary.opacity(0.6))
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    
                                    Divider()
                                        .background(AppColors.secondary.opacity(0.2))
                                    
                                    Text("Your financial data is stored securely on your device and is never sent to external servers.")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.secondary.opacity(0.7))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        
                        // Danger Zone
                        VStack(spacing: 15) {
                            Text("Danger Zone")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                    
                                    Text("Delete All Data")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.red)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .shadow(color: Color.white.opacity(0.1), radius: 8, x: -5, y: -5)
                                        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 5, y: 5)
                                )
                            }
                        }
                        
                        // Footer
                        VStack(spacing: 10) {
                            Text("Made with ❤️ for iOS")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.secondary.opacity(0.5))
                            
                            Text("© 2025 KanGold Vault")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.secondary.opacity(0.5))
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
        }
        .alert("Delete All Data", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("This will permanently delete all your expenses, investments, budgets, and savings goals. This action cannot be undone.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    private func deleteAllData() {
        DataService.shared.clearAllData()
        hasCompletedOnboarding = false
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        NeumorphicCard {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.secondary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondary.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.secondary.opacity(0.3))
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.primary)
                            .padding(.top, 40)
                        
                        Text("KanGold Vault")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.secondary)
                        
                        NeumorphicCard {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("About KanGold Vault")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                
                                Text("KanGold Vault is a comprehensive finance management app designed to help you track expenses, manage investments, and achieve your financial goals.")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Divider()
                                    .background(AppColors.secondary.opacity(0.2))
                                
                                FeatureRow(icon: "chart.bar.fill", text: "Real-time expense tracking")
                                FeatureRow(icon: "dollarsign.circle.fill", text: "Investment portfolio management")
                                FeatureRow(icon: "target", text: "Savings goals tracker")
                                FeatureRow(icon: "bell.fill", text: "Smart budget alerts")
                                FeatureRow(icon: "lock.fill", text: "Secure local storage")
                                
                                Divider()
                                    .background(AppColors.secondary.opacity(0.2))
                                
                                Text("Privacy First")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.primary)
                                
                                Text("Your financial data is stored locally on your device and never leaves your iPhone. We respect your privacy and security.")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.secondary.opacity(0.8))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        Text("Version 1.0.0")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.secondary.opacity(0.5))
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

