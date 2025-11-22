//
//  SheetCoordinator.swift.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 21/11/2025.
//
import SwiftUI


/// A protocol that describes a typed, identifiable sheet destination for use with a `SheetCoordinator`.
///
/// Conforming types represent individual sheet cases (for example, an enum of sheets),
/// and define how to render their associated SwiftUI view given a coordinator and
/// an optional, strongly-typed context.
///
/// Key points:
/// - Conformers must also conform to `Identifiable`, enabling use with SwiftUI's `.sheet(item:)`.
/// - `Body` is the SwiftUI `View` returned when presenting the sheet.
/// - `Context` is an associated data payload passed to the sheet at presentation time, enabling
///   the sheet to be configured with the necessary state (e.g., a model, coordinates, callbacks).
///
/// Usage:
/// 1. Define an enum (e.g., `enum MemorySheet: String, Identifiable, SheetEnum`) with cases for
///    each sheet you want to present.
/// 2. Implement the `view(coordinator:context:)` method to return the correct view for each case,
///    using the supplied `context` to configure the UI and the `coordinator` to drive navigation/dismissal.
/// 3. Present sheets via `SheetCoordinator`, which manages a stack/queue of sheet presentations.
///
/// - Note: `Context` can be any type, including a struct tailored to the sheet's needs. If you
///   don't need to pass data, you may use `Void` or a simple placeholder type.
/// - Important: Ensure your conforming type’s `id` is stable so SwiftUI can correctly manage sheet identity.
protocol SheetEnum: Identifiable {
    associatedtype Body: View
    associatedtype Context
    
    @ViewBuilder
    func view(coordinator: SheetCoordinator<Self>, context: Context) -> Body
}


struct MemorySheetContext {
    var coordinates: CoordinateWrapper?
    var memory: LocationMemory?
    var onSave: ((Bool, LocationMemory?) -> Void)?
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
                        isEditing: false,
                        onCompletion: { saved, memory in
                            context.onSave?(saved, memory)
                        }
                    )
                    .presentationDetents([.height(350), .large])
                    .presentationDragIndicator(.visible)
                }
            case .memoryDetail:
                Text("Memory detail placeholder")
                    .presentationDetents([.height(350), .large])
                    .presentationDragIndicator(.visible)
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
