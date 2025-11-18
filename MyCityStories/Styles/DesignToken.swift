//
//  DesignToken.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

// MARK: - Design Tokens
struct DesignTokens {
    
    // MARK: - Colors
    struct Colors {
        static let primary = Color(red: 0.2, green: 0.5, blue: 1.0) // Vibrant blue
        static let secondary = Color(.systemGray)
        static let accent = Color(red: 1.0, green: 0.4, blue: 0.6) // Coral pink
        
        static let background = Color(.systemGroupedBackground)
        static let cardBackground = Color(.systemBackground)
        static let overlayBackground = Color.black.opacity(0.3)
        
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color(.tertiaryLabel)
        
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title1 = Font.system(size: 28, weight: .bold)
        static let title2 = Font.system(size: 22, weight: .semibold)
        static let title3 = Font.system(size: 20, weight: .semibold)
        
        static let headline = Font.system(size: 17, weight: .semibold)
        static let body = Font.system(size: 17, weight: .regular)
        static let callout = Font.system(size: 16, weight: .regular)
        static let subheadline = Font.system(size: 15, weight: .regular)
        static let footnote = Font.system(size: 13, weight: .regular)
        static let caption = Font.system(size: 12, weight: .regular)
        static let caption2 = Font.system(size: 11, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
    }
    
    // MARK: - Corner Radius
    struct Radius {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let full: CGFloat = 999
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let small = {
            return Color.black.opacity(0.05)
        }
        static let medium = {
            return Color.black.opacity(0.1)
        }
        static let large = {
            return Color.black.opacity(0.15)
        }
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.spring(response: 0.25, dampingFraction: 0.8)
        static let standard = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.8)
        static let gentle = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.85)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(DesignTokens.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
            .shadow(color: DesignTokens.Shadow.small(), radius: 4, y: 2)
    }
    
    func inputFieldStyle() -> some View {
        self
            .padding(DesignTokens.Spacing.md)
            .background(DesignTokens.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
    }
    
    func sectionHeaderStyle() -> some View {
        self
            .font(DesignTokens.Typography.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}
