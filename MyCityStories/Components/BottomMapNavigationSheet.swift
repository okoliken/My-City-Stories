//
//  BottomMapNavigationSheet.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI
import SwiftData

struct BottomMapNavigationSheet: View {
    let coordinator: SheetCoordinator<MemorySheet>
    @Binding var selectedDetent: PresentationDetent
    @State var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    @Query(sort: \LocationMemory.createdDate, order: .reverse) private var allMemories: [LocationMemory]
    
    private var recentMemories: [LocationMemory] {
        Array(allMemories.prefix(7))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                // Recent Places Section
                if !recentMemories.isEmpty {
                    recentPlacesSection
                } else {
                    emptyStateView
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.top, DesignTokens.Spacing.sm)
            .padding(.bottom, DesignTokens.Spacing.xl)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    ZStack(alignment: .leading) {
                        TextField("Search maps", text: $searchText)
                            .padding(.vertical, 10)
                            .padding(.leading, 40)
                            .fontWeight(.medium)
                            .background(
                                Capsule()
                                    .fill(DesignTokens.Colors.cardBackground)
                            )
                            .focused($isFocused)
                            .onChange(of: isFocused) { oldValue, newValue in
                                if newValue {
                                    searchText = ""
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        selectedDetent = .large
                                    }
                                }
                            }
                        
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .padding(.leading, 12)
                    }
                    Button {
                        
                    } label: {
                        Circle()
                            .fill(Color.inputBG)
                            .frame(width: 35, height: 35)
                    }
                }
            }
            .padding(18)
        }
    }
    
    // MARK: - Recent Places Section
    private var recentPlacesSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: 4){
                Text("Recent Places")
                    .font(DesignTokens.Typography.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignTokens.Colors.textColorTheme)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.xs)
            
            recentPlacesList
        }
    }
    
    // MARK: - Recent Places List
    private var recentPlacesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(recentMemories) { memory in
                    RecentPlaceCard(memory: memory, coordinator: coordinator)
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.xs)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: "mappin.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary.opacity(0.5))
            
            Text("No Memories Yet")
                .font(DesignTokens.Typography.headline)
                .foregroundStyle(DesignTokens.Colors.textColorTheme)
            
            Text("Create your first memory by long-pressing on the map")
                .font(DesignTokens.Typography.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignTokens.Spacing.xxl)
    }
}

// MARK: - Recent Place Card
struct RecentPlaceCard: View {
    let memory: LocationMemory
    let coordinator: SheetCoordinator<MemorySheet>
    
    var body: some View {
        Button {
            coordinator.presentSheet(.memoryDetail, context: .init(memory: memory))
        } label: {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                // Photo Thumbnail or Category Icon
                thumbnailView
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    // Title
                    Text(memory.title)
                        .font(DesignTokens.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(DesignTokens.Colors.textColorTheme)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Category Badge
                    categoryBadge
                    
                    // Date
                    Text(relativeDateString(from: memory.createdDate))
                        .font(DesignTokens.Typography.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(DesignTokens.Spacing.sm)
            .frame(width: 200)
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
        .buttonStyle(.plain)
    }
    
    // MARK: - Thumbnail View
    private var thumbnailView: some View {
        Group {
            if let firstPhoto = memory.photos.first {
                Image(uiImage: firstPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm))
            } else {
                // Category Icon Fallback
                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    memory.category.color.opacity(0.2),
                                    memory.category.color.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 132, height: 100)
                    
                    Image(systemName: memory.category.icon)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(memory.category.color)
                }
            }
        }
    }
    
    // MARK: - Category Badge
    private var categoryBadge: some View {
        HStack(spacing: DesignTokens.Spacing.xxs) {
            Image(systemName: memory.category.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(memory.category.rawValue)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, DesignTokens.Spacing.xs)
        .padding(.vertical, 2)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            memory.category.color,
                            memory.category.color.opacity(0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
    }
    
    // MARK: - Helpers
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
