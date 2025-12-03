//
//  GuideCard.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct GuideCard: View {
  let icon: String
  let iconColor: Color
  let title: String
  let count: Int

  var body: some View {
    VStack(spacing: DesignTokens.Spacing.sm) {
      HStack {
        Spacer()
        Button {
          // Menu action
        } label: {
          Image(systemName: "ellipsis")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
      }

      Image(systemName: icon)
        .font(.system(size: 32, weight: .medium))
        .foregroundStyle(iconColor)

      VStack(spacing: 2) {
        Text(title)
          .font(DesignTokens.Typography.subheadline)
          .fontWeight(.semibold)
          .foregroundStyle(DesignTokens.Colors.textColorTheme)

        Text("\(count) places")
          .font(DesignTokens.Typography.caption)
          .foregroundStyle(.secondary)
      }

      Spacer()
    }
    .frame(width: 140, height: 140)
    .padding(DesignTokens.Spacing.md)
    .background(
      RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
        .fill(.ultraThinMaterial)
    )
    .overlay(
      RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
        .strokeBorder(
          LinearGradient(
            gradient: Gradient(colors: [
              Color.white.opacity(0.2),
              Color.white.opacity(0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 1
        )
    )
    .shadow(color: DesignTokens.Shadow.small(), radius: 4, y: 2)
  }
}

