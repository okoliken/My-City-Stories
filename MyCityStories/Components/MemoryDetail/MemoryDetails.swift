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
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // MARK: - Title (First, Centered)
                    Text(memory.title)
                        .font(DesignTokens.Typography.title1)
                        .fontWeight(.bold)
                        .foregroundStyle(DesignTokens.Colors.textColorTheme)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, DesignTokens.Spacing.lg)
                    
                    // MARK: - Photos Section
                    if !memory.photos.isEmpty {
                        photoSection
                    }
                    
                    // MARK: - Details Section
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        // Date
                        detailRow(
                            icon: "calendar",
                            title: "Date",
                            value: formattedDate(memory.date)
                        )
                        
                        // Category
                        detailRow(
                            icon: memory.category.icon,
                            title: "Category",
                            value: memory.category.rawValue,
                            categoryColor: memory.category.color
                        )
                        
                        // Location
                        detailRow(
                            icon: "mappin.circle.fill",
                            title: "Location",
                            value: formattedLocation(memory.latitude, memory.longitude)
                        )
                        
                        // Note (if available)
                        if let note = memory.note, !note.isEmpty {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                Text("Note")
                                    .sectionHeaderStyle()
                                
                                Text(note)
                                    .font(DesignTokens.Typography.body)
                                    .foregroundStyle(DesignTokens.Colors.textColorTheme)
                                    .padding(DesignTokens.Spacing.md)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(DesignTokens.Colors.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, DesignTokens.Spacing.xl)
                }
            }
            .background(DesignTokens.Colors.cardBackground)
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
    
    // MARK: - Photo Section
    private var photoSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.md) {
                ForEach(Array(memory.photos.enumerated()), id: \.offset) { index, photo in
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
                        .clipped()
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md)
        }
        .frame(height: 180)
    }
    
    // MARK: - Detail Row
    private func detailRow(
        icon: String,
        title: String,
        value: String,
        categoryColor: Color? = nil
    ) -> some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(categoryColor ?? DesignTokens.Colors.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(title)
                    .font(DesignTokens.Typography.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(DesignTokens.Typography.body)
                    .foregroundStyle(DesignTokens.Colors.textColorTheme)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, DesignTokens.Spacing.sm)
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

