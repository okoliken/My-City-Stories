//
//  RecentMemoryRow.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftData
import SwiftUI

struct RecentMemoryRow: View {
  let memory: LocationMemory
  let coordinator: SheetCoordinator<MemorySheet>

  var body: some View {
    Button {
      coordinator.presentSheet(.memoryDetail, context: .init(memory: memory))
    } label: {
      HStack(spacing: DesignTokens.Spacing.md) {
        ZStack {
          Circle()
            .fill(memory.category.color.opacity(0.15))
            .frame(width: 40, height: 40)
          Image(systemName: memory.category.icon)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(memory.category.color)
        }

        VStack(alignment: .leading, spacing: 2) {
          Text(memory.title)
            .font(DesignTokens.Typography.body)
            .fontWeight(.medium)
            .foregroundStyle(DesignTokens.Colors.textColorTheme)
            .lineLimit(1)

          Text(relativeDateString(from: memory.createdDate))
            .font(DesignTokens.Typography.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }

        Spacer()

        Button {
          // Show menu
        } label: {
          Image(systemName: "ellipsis")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.secondary)
            .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
      }
      .padding(.horizontal, DesignTokens.Spacing.md)
      .padding(.vertical, DesignTokens.Spacing.sm)
    }
    .buttonStyle(.plain)
  }

  private func relativeDateString(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()

    if calendar.isDateInToday(date) {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      return "Today at \(formatter.string(from: date))"
    } else if calendar.isDateInYesterday(date) {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      return "Yesterday at \(formatter.string(from: date))"
    } else {
      let daysAgo = calendar.dateComponents([.day], from: date, to: now).day ?? 0
      if daysAgo < 7 {
        return "\(daysAgo) days ago"
      } else {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
      }
    }
  }
}

