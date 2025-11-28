//
//  MemoryDetails.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI
import SwiftData
import MapKit

struct MemoryDetailsView: View {
    let memory: LocationMemory
    @Environment(\.dismiss) private var dismiss
    @State private var currentPhotoIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // MARK: - Title Section
                    titleSection
                    
                    // MARK: - Photos Section
                    if !memory.photos.isEmpty {
                        photoSection
                    }
                    
                    // MARK: - Details Cards
                    detailsSection
                    
                    // MARK: - Note Section
                    if let note = memory.note, !note.isEmpty {
                        noteSection(note)
                    }
                }
                .padding(.bottom, DesignTokens.Spacing.xxl)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(DesignTokens.Colors.textColorTheme)
                    }
                }
            }
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Text(memory.title)
                .font(DesignTokens.Typography.title1)
                .fontWeight(.bold)
                .foregroundStyle(DesignTokens.Colors.textColorTheme)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.top, DesignTokens.Spacing.lg)
            
            // Category Badge
            categoryBadge
        }
    }
    
    // MARK: - Category Badge
    private var categoryBadge: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: memory.category.icon)
                .font(.system(size: 12, weight: .semibold))
            Text(memory.category.rawValue)
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.xs)
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
        .shadow(color: memory.category.color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Photo Section
    private var photoSection: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            TabView(selection: $currentPhotoIndex) {
                ForEach(Array(memory.photos.enumerated()), id: \.offset) { index, photo in
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
            .padding(.horizontal, DesignTokens.Spacing.md)
            
            // Photo counter
            if memory.photos.count > 1 {
                Text("\(currentPhotoIndex + 1) of \(memory.photos.count)")
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Details Section
    private var detailsSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            // Date Card
            detailCard(
                icon: "calendar",
                iconColor: DesignTokens.Colors.primary,
                title: "Date",
                value: formattedDate(memory.date)
            )
            
            // Location Card
            detailCard(
                icon: "mappin.circle.fill",
                iconColor: .red,
                title: "Location",
                value: formattedLocation(memory.latitude, memory.longitude)
            )
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
    }
    
    // MARK: - Detail Card
    private func detailCard(
        icon: String,
        iconColor: Color,
        title: String,
        value: String
    ) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                iconColor.opacity(0.2),
                                iconColor.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(title)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(value)
                    .font(DesignTokens.Typography.body)
                    .fontWeight(.medium)
                    .foregroundStyle(DesignTokens.Colors.textColorTheme)
            }
            
            Spacer()
        }
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
    
    // MARK: - Note Section
    private func noteSection(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DesignTokens.Colors.primary)
                
                Text("Note")
                    .font(DesignTokens.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignTokens.Colors.textColorTheme)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }
            
            Text(note)
                .font(DesignTokens.Typography.body)
                .foregroundStyle(DesignTokens.Colors.textColorTheme)
                .lineSpacing(4)
                .padding(DesignTokens.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
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
        .padding(.horizontal, DesignTokens.Spacing.md)
    }
    
    // MARK: - Helpers
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedLocation(_ latitude: Double, _ longitude: Double) -> String {
        String(format: "%.4f, %.4f", latitude, longitude)
    }
}
