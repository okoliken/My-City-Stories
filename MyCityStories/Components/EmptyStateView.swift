//
//  EmptyStateView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import SwiftUI

struct EmptyStateView: View {
    let hasMemories: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: hasMemories ? "magnifyingglass" : "map")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(hasMemories ? "No results" : "No memories yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(hasMemories ? "Try adjusting your filters" : "Tap the map to drop a pin and create your first memory")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if !hasMemories {
                Button {
                    // Navigate to map
                } label: {
                    Text("Go to Map")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
    }
}
