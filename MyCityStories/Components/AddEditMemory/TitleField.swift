//
//  TitleField.swift
//  MyCityStories
//
//  Improved with Design System
//

import SwiftUI

struct TitleField: View {
    @Binding var title: String
    @FocusState private var isFocused: Bool
    
    let titleLimit: Int = 50
    
    private var isError: Bool {
        title.trimmingCharacters(in: .whitespaces).isEmpty && !title.isEmpty
    }
    
    private var characterCount: Int {
        title.count
    }
    
    private var isNearLimit: Bool {
        characterCount > Int(Double(titleLimit) * 0.8)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            // Header
            HStack {
                Text("Title")
                    .sectionHeaderStyle()
                
                Spacer()
                
                // Character counter with dynamic color
                Text("\(characterCount)/\(titleLimit)")
                    .font(DesignTokens.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(characterCountColor)
                    .padding(.horizontal, DesignTokens.Spacing.xs)
                    .padding(.vertical, DesignTokens.Spacing.xxs)
                    .background(
                        Capsule()
                            .fill(characterCountColor.opacity(0.1))
                    )
            }
            
            // Input field with focus state
            TextField("Pizza night, Beach day...", text: $title)
                .font(DesignTokens.Typography.body)
                .focused($isFocused)
                .padding(DesignTokens.Spacing.md)
                .background(DesignTokens.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
                .animation(DesignTokens.Animation.quick, value: isFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
                )
                .onChange(of: title) { oldValue, newValue in
                    if newValue.count > titleLimit {
                        title = String(newValue.prefix(titleLimit))
                    }
                }
            
            // Error message
            if isError {
                Text("Title cannot be empty")
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(DesignTokens.Colors.error)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(DesignTokens.Animation.standard, value: isError)
    }
    
    private var borderColor: Color {
        if isError {
            return DesignTokens.Colors.error
        } else if isFocused {
            return DesignTokens.Colors.primary
        } else {
            return Color(.inputBorder)
        }
    }
    
    private var characterCountColor: Color {
        if characterCount > titleLimit {
            return DesignTokens.Colors.error
        } else if isNearLimit {
            return DesignTokens.Colors.warning
        } else {
            return DesignTokens.Colors.textColorTheme
        }
    }
}

