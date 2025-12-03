//
//  MapAnnotationPin.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct MapAnnotationPin: View {
    let memory: LocationMemory
    let iconName: (_ category: Category) -> String
    
    @State private var scale: CGFloat = 0.0
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                memory.category.color.opacity(0.4),
                                memory.category.color.opacity(0.1),
                                .clear
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Circle()
                    .fill(memory.category.color.opacity(0.25))
                    .frame(width: 40, height: 40)
                    .blur(radius: 6)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                memory.category.color.opacity(0.95),
                                memory.category.color,
                                memory.category.color.opacity(0.85)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.8),
                                        Color.white.opacity(0.4)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: memory.category.color.opacity(0.5), radius: 4, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                .clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .frame(width: 32, height: 32)
                    .blur(radius: 2)
                
                Image(systemName: iconName(memory.category))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
            }
        

            Text(memory.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.1),
                                        .clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                )
        }
        .scaleEffect(scale)
        .animation(.bouncy, value: scale)
        .onAppear {
            scale = 1.0
        }
    }
}
