//
//  ActionButton.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct ActionButton: View {
  let icon: String
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: DesignTokens.Spacing.md) {
        Image(systemName: icon)
          .font(.system(size: 18, weight: .medium))
          .foregroundStyle(.blue)
          .frame(width: 24)

        Text(title)
          .font(DesignTokens.Typography.body)
          .fontWeight(.medium)
          .foregroundStyle(DesignTokens.Colors.textColorTheme)

        Spacer()
      }
      .padding(.horizontal, DesignTokens.Spacing.md)
      .padding(.vertical, DesignTokens.Spacing.sm)
      .background(
        RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
          .fill(Color.blue.opacity(0.1))
      )
    }
    .buttonStyle(.plain)
  }
}

