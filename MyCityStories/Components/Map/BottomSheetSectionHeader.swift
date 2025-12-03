//
//  BottomSheetSectionHeader.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct BottomSheetSectionHeader: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 4) {
        Text(title)
          .font(DesignTokens.Typography.headline)
          .fontWeight(.semibold)
          .foregroundStyle(DesignTokens.Colors.textColorTheme)
        Image(systemName: "chevron.right")
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(.secondary)
        Spacer()
      }
      .padding(.horizontal, DesignTokens.Spacing.md)
      .padding(.vertical, DesignTokens.Spacing.sm)
    }
    .buttonStyle(.plain)
  }
}

