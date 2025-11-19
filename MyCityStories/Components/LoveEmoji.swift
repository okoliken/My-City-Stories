//
//  LoveEmoji.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 19/11/2025.
//

import SwiftUI

struct LoveEmoji: View {
    enum AnimationPhase: CaseIterable {
        case initial
        case move
        case scale
        
        var verticalOffset: Double {
            switch self {
                case .initial: 0
                case .move, .scale: -64
            }
        }
        
        var scaleEffect: Double {
            switch self {
                case .initial: 1
                case .move, .scale: 1.5
            }
        }
    }
    
    @State private var likeCount = 0
    
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 100))
            .phaseAnimator(AnimationPhase.allCases, trigger: likeCount) { content, phase in
                content
                    .offset(y: phase.verticalOffset)
                    .scaleEffect(phase.scaleEffect)
            } animation: { phase in
                switch phase {
                    case .initial: .smooth
                    case .move: .easeInOut(duration: 0.3)
                    case .scale: .spring(duration: 0.3, bounce: 0.7)
                }
            }
            .onTapGesture {
                likeCount += 1
            }
    }
}

#Preview {
    LoveEmoji()
}
