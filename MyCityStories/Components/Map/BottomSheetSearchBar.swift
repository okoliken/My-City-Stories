//
//  BottomSheetSearchBar.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct BottomSheetSearchBar: View {
  @Binding var searchText: String
  @Binding var selectedDetent: PresentationDetent
  @FocusState var isFocused: Bool

  var body: some View {
    HStack(spacing: DesignTokens.Spacing.sm) {
      HStack(spacing: DesignTokens.Spacing.xs) {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(.secondary)
          .fontWeight(.semibold)

        TextField("Search Maps", text: $searchText)
          .font(DesignTokens.Typography.body)
          .focused($isFocused)
          .onChange(of: isFocused) { oldValue, newValue in
            if newValue {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedDetent = .large
              }
            }
          }

        if !searchText.isEmpty {
          Button {
            searchText = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.secondary)
          }
        }
      }
      .padding(.horizontal, DesignTokens.Spacing.md)
      .padding(.vertical, 10)
      .background(
        Capsule()
          .fill(.ultraThinMaterial)
      )
      .overlay(
        Capsule()
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

      Button {
      } label: {
        ZStack {
          Circle()
            .fill(Color.blue.opacity(0.1))
            .frame(width: 36, height: 36)
          Text("AA")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.blue)
        }
      }
    }
    .padding(.horizontal, DesignTokens.Spacing.md)
    .padding(.vertical, DesignTokens.Spacing.sm)
  }
}

