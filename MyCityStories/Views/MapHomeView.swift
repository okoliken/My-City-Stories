//
//  MapHomeView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//


import SwiftUI
import MapKit




struct MemoryMapView: View {
    @State private var openNewpinSheet: Bool = false
    @State var showBottomMapNavigationSheet: Bool = true
    @State var selectedMemoryCoordinates: CoordinateWrapper? = nil
    @State private var memories: [LocationMemory] = []
    @State private var pendingMemoryID: UUID? = nil
    @State private var pendingWasSaved: Bool = false
    @State private var coordinator = SheetCoordinator<MemorySheet>()
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.7749,
                longitude: -122.4194
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
    )
    
    
    
    func saveMemory(memory: LocationMemory?, saved: Bool) {
        if !saved, let id = pendingMemoryID {
            memories.removeAll { $0.id == id }
            pendingMemoryID = nil
        } else if saved {
            pendingMemoryID = nil
            let newMemoryId = memory?.id
            if let memory = memory, let index = memories.firstIndex(where: { $0.id == newMemoryId }) {
                memories[index] = memory
            } else if let memory  {
                memories.append(memory)
            }
        }
    }
    
    func createMemoryDraft(at coordinate: CLLocationCoordinate2D) {
        let newMemory = LocationMemory(
            id: UUID(),
            title: "",
            note: "",
            date: Date(),
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            category: .other
        )
        memories.append(newMemory)
        pendingMemoryID = newMemory.id
        selectedMemoryCoordinates = CoordinateWrapper(coordinate)
    }
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(memories, id: \.id) { memory in
                        let coordinate = CLLocationCoordinate2D(
                            latitude: memory.latitude,
                            longitude: memory.longitude
                        )
                        Annotation(
                            memory.title,
                            coordinate: coordinate
                        ) {
                            MapAnnotationPin(
                                memory: memory
                            ) { selectedLocationMemory in
                                iconName(
                                    for: selectedLocationMemory
                                )
                            }
                            
                        }
                        .annotationTitles(.hidden)
                        
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .mapStyle(.standard(
                    elevation: .realistic,
                    pointsOfInterest: .including([.publicTransport, .park]),
                    showsTraffic: false
                ))
                
                .mapControlVisibility(.visible)
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { value in
                            switch value {
                                case .second(true, let drag):
                                    if let location = drag?.location,
                                       let coordinate = proxy.convert(location, from: .local) {
                                        self.createMemoryDraft(at: coordinate)
                                    }
                                default:
                                    break
                            }
                        }
                )
                .onAppear {
                    //                mapManager.requestWhenInUseAuthorization()
                    //                             let center = CLLocationCoordinate2D(latitude: 6.458985, longitude: 3.601521)
                    //                             let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    //                             let region = MKCoordinateRegion(center: center, span: span)
                    //
                    //                    position = .region(a)
                }
                .onChange(of: selectedMemoryCoordinates) { _, newValue in
                    if let coord = newValue {
                        let context = MemorySheetContext(
                            coordinates: coord,
                            memory: nil,
                            onSave: { saved, memory in
                                pendingWasSaved = saved
                                self.saveMemory(memory: memory, saved: saved)
                            }
                        )
                        coordinator.presentSheet(.memoryForm, context: context)
                    }
                }
                .onChange(of: coordinator.currentSheet) { oldValue, newValue in
                    if newValue == nil && oldValue != nil {
                        if let id = pendingMemoryID, !pendingWasSaved {
                            memories.removeAll { $0.id == id }
                            pendingMemoryID = nil
                        }
                    }
                }
                .sheet(isPresented: $showBottomMapNavigationSheet) {
                    BottomMapNavigationSheet(coordinator: coordinator)
                        .presentationDetents([.height(70), .height(350), .large])
                        .presentationBackgroundInteraction(.enabled)
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled()
                        .sheetCoordinating(coordinator: coordinator)
                }
                
            }
        }
        
    }
    
    private func iconName(for category: Category) -> String {
        switch category {
            case .food: return "fork.knife"
            case .friends: return "person.2.fill"
            case .travel: return "airplane"
            case .work: return "briefcase.fill"
            case .other: return "mappin"
        }
    }
    
    
}


struct BottomMapNavigationSheet: View {
    let coordinator: SheetCoordinator<MemorySheet>
    
    var body: some View {
        Button {
            print("Map settings placeholder")
            coordinator.presentSheet(.memoryDetail, context: MemorySheetContext(coordinates: nil, memory: nil, onSave: nil))
        } label: {
            Text("Hello")
        }
        
    }
}

#Preview {
    NavigationStack {
        MemoryMapView()
    }
}
