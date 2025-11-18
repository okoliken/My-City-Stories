//
//  NoteField.swift
//  MyCityStories
//
//  Improved with Design System
//

import SwiftUI

struct NoteField: View {
    @Binding var note: String
    @FocusState private var isFocused: Bool
    
    let noteLimit = 500
    
    private var characterCount: Int {
        note.count
    }
    
    private var isNearLimit: Bool {
        characterCount > Int(Double(noteLimit) * 0.8)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            // Header
            HStack(alignment: .center, spacing: DesignTokens.Spacing.xs) {
                Label("Note", systemImage: "note.text")
                    .sectionHeaderStyle()
                
                Text("Optional")
                    .font(DesignTokens.Typography.caption2)
                    .foregroundStyle(DesignTokens.Colors.textTertiary)
                    .padding(.horizontal, DesignTokens.Spacing.xs)
                    .padding(.vertical, DesignTokens.Spacing.xxs)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray6))
                    )
                
                Spacer()
                
                // Character counter
                Text("\(characterCount)/\(noteLimit)")
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
            
            // Text editor with placeholder
            ZStack(alignment: .topLeading) {
                // Placeholder - matches TextEditor padding exactly
                if note.isEmpty {
                    Text("Add details about this memory...")
                        .font(DesignTokens.Typography.body)
                        .foregroundStyle(DesignTokens.Colors.textTertiary.opacity(0.6))
                        .padding(.horizontal, 4) // TextEditor has ~4pt internal horizontal padding
                        .padding(.vertical, 8)   // TextEditor has ~8pt internal vertical padding
                        .padding(DesignTokens.Spacing.md) // Match outer padding
                        .allowsHitTesting(false)
                }
                
                // Text editor
                TextEditor(text: $note)
                    .font(DesignTokens.Typography.body)
                    .focused($isFocused)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .padding(DesignTokens.Spacing.md)
                    .onChange(of: note) { oldValue, newValue in
                        if newValue.count > noteLimit {
                            note = String(newValue.prefix(noteLimit))
                        }
                    }
            }
            .background(DesignTokens.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .shadow(color: isFocused ? DesignTokens.Colors.primary.opacity(0.15) : .clear,
                   radius: 8, y: 4)
            .animation(DesignTokens.Animation.quick, value: isFocused)
        }
    }
    
    private var borderColor: Color {
        if isFocused {
            return DesignTokens.Colors.primary
        } else {
            return Color(.systemGray5)
        }
    }
    
    private var characterCountColor: Color {
        if characterCount > noteLimit {
            return DesignTokens.Colors.error
        } else if isNearLimit {
            return DesignTokens.Colors.warning
        } else {
            return DesignTokens.Colors.textSecondary
        }
    }
}
