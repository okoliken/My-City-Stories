//
//  BottomMapNavigationSheet.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftData
import SwiftUI

struct BottomMapNavigationSheet: View {
  let coordinator: SheetCoordinator<MemorySheet>
  @Binding var selectedDetent: PresentationDetent
  @State var searchText: String = ""
  @FocusState private var isFocused: Bool

  @Query(sort: \LocationMemory.createdDate, order: .reverse) private var allMemories:
    [LocationMemory]

  private var recentMemories: [LocationMemory] {
    Array(allMemories.prefix(10))
  }

  private var favoriteMemories: [LocationMemory] {
    allMemories.filter { $0.isFavorite }
  }

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 0) {
        if !recentMemories.isEmpty {
          recentsSection
        }

        // Your Guides Section
        yourGuidesSection

        // Action Buttons
        actionButtonsSection

        // Terms & Conditions
        termsSection
      }
      .padding(.top, DesignTokens.Spacing.sm)
      .padding(.bottom, DesignTokens.Spacing.xl)
    }
    .safeAreaInset(edge: .top, spacing: 0) {
      searchBarSection
    }
  }

  // MARK: - Search Bar Section
  private var searchBarSection: some View {
    BottomSheetSearchBar(
      searchText: $searchText,
      selectedDetent: $selectedDetent
    )
  }

  // MARK: - Recents Section
  private var recentsSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Section Header
      BottomSheetSectionHeader(title: "Recents") {
        coordinator.presentSheet(.memoriesList, context: nil)
      }

      // Recent Items List
      VStack(spacing: 0) {
        ForEach(Array(recentMemories.enumerated()), id: \.element.id) { index, memory in
          RecentMemoryRow(memory: memory, coordinator: coordinator)
          if index < recentMemories.count - 1 {
            Divider()
          }
        }
      }
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
      .padding(.horizontal, DesignTokens.Spacing.md)
    }
    .padding(.bottom, DesignTokens.Spacing.lg)
  }

  // MARK: - Your Guides Section
  private var yourGuidesSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Section Header
      BottomSheetSectionHeader(title: "Your Guides") {
        // Show all guides
      }

      // Guides Cards
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: DesignTokens.Spacing.md) {
          // Favorites Guide
          GuideCard(
            icon: "star.fill",
            iconColor: .orange,
            title: "Favorites",
            count: favoriteMemories.count
          )

          // New Guide
          GuideCard(
            icon: "book.fill",
            iconColor: .gray,
            title: "New",
            count: 0
          )
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
      }
    }
    .padding(.bottom, DesignTokens.Spacing.lg)
  }

  // MARK: - Action Buttons Section
  private var actionButtonsSection: some View {
    VStack(spacing: DesignTokens.Spacing.sm) {
      ActionButton(
        icon: "square.and.arrow.up",
        title: "Share My Location"
      ) {
        // Share location action
      }

      ActionButton(
        icon: "mappin",
        title: "Mark My Location"
      ) {
        // Mark location action
      }

      ActionButton(
        icon: "info.bubble",
        title: "Report an Issue"
      ) {
        // Report issue action
      }
    }
    .padding(.horizontal, DesignTokens.Spacing.md)
    .padding(.bottom, DesignTokens.Spacing.lg)
  }

  // MARK: - Terms Section
  private var termsSection: some View {
    Button {
      // Show terms
    } label: {
      HStack {
        Text("Terms & Conditions")
          .font(DesignTokens.Typography.footnote)
          .foregroundStyle(.secondary)
        Image(systemName: "chevron.right")
          .font(.system(size: 10, weight: .semibold))
          .foregroundStyle(.secondary)
        Spacer()
      }
      .padding(.horizontal, DesignTokens.Spacing.md)
    }
    .buttonStyle(.plain)
  }
}
