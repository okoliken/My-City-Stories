//
//  MapHomeView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//


import SwiftUI
import MapKit

// Local model to satisfy the dummy data and map annotations
struct LocationMemory: Identifiable {
    enum Category {
        case food
        case friends
        case travel
        case work
        case other
        
        var color: Color {
            switch self {
                case .food: return .orange
                case .friends: return .blue
                case .travel: return .purple
                case .work: return .green
                case .other: return .red
            }
        }
    }
    
    let id: UUID
    let title: String
    let note: String? // optional so `nil` is allowed
    let date: Date
    let latitude: Double
    let longitude: Double
    let category: Category
}

struct CoordinateWrapper: Equatable {
    let latitude: Double
    let longitude: Double
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MemoryMapView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var openNewpinSheet: Bool = false
    @State var showBottomMapNavigationSheet: Bool = true
    @State var selectedMemoryCoordinates: CoordinateWrapper? = nil

    @State private var memories: [LocationMemory] = [
        .init(id: UUID(), title: "Chicken republic - Rumuesera", note: "Really enjoyed the food, plus it's really close by", date: Date(), latitude: 6.458985, longitude: 3.601521, category: .food)
    ]
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(memories) { memory in
                        let coordinate = CLLocationCoordinate2D(latitude: memory.latitude, longitude: memory.longitude)
                        Annotation(memory.title, coordinate: coordinate) {
                            MapAnnotationPin(memory: memory) { selectedLocationMemory in
                                iconName(for: selectedLocationMemory)
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
                .mapStyle(.standard(elevation: .realistic))
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { value in
                            switch value {
                                case .second(true, let drag):
                                    if let location = drag?.location,
                                       let coordinate = proxy.convert(location, from: .local) {
                                        memories
                                            .append(
                                                LocationMemory(
                                                    id: UUID(),
                                                    title: "",
                                                    note: "",
                                                    date: Date(),
                                                    latitude: coordinate.latitude,
                                                    longitude: coordinate.longitude,
                                                    category: .other
                                                )
                                            )
                                        selectedMemoryCoordinates = CoordinateWrapper(
                                            coordinate
                                        )
                                        
                                        
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
                        .sheet(isPresented: $openNewpinSheet) {
                            if let coord = selectedMemoryCoordinates {
                                AddEditMemoryView(latitude: coord.latitude, longitude: coord.longitude, isEditing: false)
                                    .presentationDetents([.height(350), .large])
                                    .presentationDragIndicator(.visible)
                            }
                        }
                }
               
                
            }
        }
    
    }
    
    private func iconName(for category: LocationMemory.Category) -> String {
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
