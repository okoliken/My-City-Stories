//
//  AnnotationPinButton.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftUI

struct AnnotationPinButton: View {
    let memory: LocationMemory
    let iconName: (Category) -> String
    let coordinator: SheetCoordinator<MemorySheet>
    
    @State private var triggerWiggle = false
    
    var body: some View {
        Button {
            triggerWiggle.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let context = MemorySheetContext(
                    coordinates: nil,
                    memory: memory,
                    onSave: nil
                )
                coordinator.presentSheet(.memoryDetail, context: context)
            }
        } label: {
            MapAnnotationPin(
                memory: memory,
                iconName: iconName
            )
        }
        .buttonStyle(.plain)
    }
}

