//
//  MemoryCardView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import SwiftUI

struct MemoryCardView: View {
    let memory: Memory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            ZStack {
                if let imageName = memory.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    // Placeholder with gradient
                    LinearGradient(
                        colors: [memory.category.color.opacity(0.6), memory.category.color.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                
                // Category badge
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: memory.category.icon)
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(memory.category.color)
                            .clipShape(Circle())
                            .padding(8)
                    }
                    Spacer()
                }
            }
            .frame(height: 140)
            .clipped()
            
            // Memory info
            VStack(alignment: .leading, spacing: 4) {
                Text(memory.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(memory.note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Text(memory.date, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
    }
}
