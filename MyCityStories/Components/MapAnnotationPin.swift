//
//  MapAnnotationPin.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct MapAnnotationPin: View {
    let memory: LocationMemory
    let iconName: (_ category: LocationMemory.Category) -> String
    
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Outer glow effect
                Circle()
                    .fill(memory.category.color.opacity(0.3))
                    .frame(width: 36, height: 36)
                    .blur(radius: 4)
                
                // Main circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                memory.category.color.opacity(0.9),
                                memory.category.color
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                    )
                
                // Icon
                Image(systemName: iconName(memory.category))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            }
            
            // Label with improved styling
            Text(memory.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.white.opacity(0.5), lineWidth: 0.5)
                )
        }
        .shadow(color: memory.category.color.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}
