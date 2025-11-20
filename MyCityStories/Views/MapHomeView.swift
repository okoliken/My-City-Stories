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
                .mapStyle(.hybrid(
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
                                        pendingWasSaved = false
                                        selectedMemoryCoordinates = CoordinateWrapper(coordinate)
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
                .onChange(of: selectedMemoryCoordinates) {
                    openNewpinSheet = true
                }
                .sheet(isPresented: $showBottomMapNavigationSheet) {
                    BottomMapNavigationSheet()
                        .presentationDetents([.height(70), .height(350), .large])
                        .presentationBackgroundInteraction(.enabled)
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled()
                        .sheet(isPresented: $openNewpinSheet, onDismiss: {
                            if let id = pendingMemoryID {
                                memories.removeAll { $0.id == id }
                                pendingMemoryID = nil
                            }
                        }) {
                            if let coord = selectedMemoryCoordinates {
                                AddEditMemoryView(latitude: coord.latitude, longitude: coord.longitude, isEditing: false, onCompletion: { saved, memory in
                                    pendingWasSaved = saved
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
                                })
                                .presentationDetents([.height(350), .large])
                                .presentationDragIndicator(.visible)
                            }
                        }
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
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    NavigationStack {
        MemoryMapView()
    }
}
