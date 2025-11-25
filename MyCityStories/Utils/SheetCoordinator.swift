//
//  SheetCoordinator.swift.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 21/11/2025.
//
import SwiftUI

protocol SheetEnum: Identifiable {
    associatedtype Body: View
    associatedtype Context
    
    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>, context: Context) -> Body
}


struct MemorySheetContext {
    var coordinates: CoordinateWrapper?
    var memory: LocationMemory?
    var onSave: ((Bool, LocalLocationMemory?) -> Void)?
}

enum MemorySheet: String, SheetEnum {
    case memoryForm
    case memoryDetail
    case mapSettings
    
    var id: String { rawValue }
    
    @ViewBuilder
    func view(coordinator: SheetCoordinator<MemorySheet>, context: MemorySheetContext) -> some View {
        switch self {
            case .memoryForm:
                if let coord = context.coordinates {
                    AddEditMemoryView(
                        latitude: coord.latitude,
                        longitude: coord.longitude,
                        isEditing: context.memory != nil,
                        memory: context.memory,
                        onCompletion: { saved, memory in
                            context.onSave?(saved, memory)
                        }
                    )
                    .presentationDetents([.height(350), .large])
                    .presentationDragIndicator(.visible)
                }
            case .memoryDetail:
                if let memory = context.memory {
                    MemoryDetailsView(memory: memory)
                        .presentationDetents([.height(500), .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color.inputBG)
                }
            case .mapSettings:
                Text("Map settings placeholder")
                    .presentationDetents([.height(70), .height(350), .large])
                    .presentationDragIndicator(.visible)
        }
    }
}


@Observable
final class SheetCoordinator<Sheet: SheetEnum> {
    var currentSheet: Sheet?
    var context: Sheet.Context?
    private var sheetStack: [(sheet: Sheet, context: Sheet.Context?)] = []
    
    @MainActor
    func presentSheet(_ sheet: Sheet, context: Sheet.Context? = nil) {
        sheetStack.append((sheet, context))
        
        if sheetStack.count == 1 {
            self.context = context
            currentSheet = sheet
        }
    }
    @MainActor
    func sheetDismissed() {
        sheetStack.removeFirst()
        
        if let next = sheetStack.first {
            self.context = next.context
            currentSheet = next.sheet
        } else {
            context = nil
            currentSheet = nil
        }
    }
}

@MainActor
struct SheetCoordinating<Sheet: SheetEnum>: ViewModifier {
    @Bindable var coordinator: SheetCoordinator<Sheet>
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $coordinator.currentSheet, onDismiss: {
                coordinator.sheetDismissed()
            }, content: { sheet in
                sheet.view(coordinator: coordinator, context: coordinator.context!)
            })
    }
}
extension View {
    func sheetCoordinating<Sheet: SheetEnum>(coordinator: SheetCoordinator<Sheet>) -> some View {
        modifier(SheetCoordinating(coordinator: coordinator))
    }
}
