//
//  FilterChip.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//
import SwiftUI

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}
