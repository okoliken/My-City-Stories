//
//  MapHomeView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//


import SwiftUI
import MapKit
import SwiftData


struct MemoryMapView: View {
    @Query(sort: \LocationMemory.createdDate, order: .reverse) private var memories: [LocationMemory]
    @State private var openNewpinSheet: Bool = false
    @State var showBottomMapNavigationSheet: Bool = true
    @State var selectedMemoryCoordinates: CoordinateWrapper? = nil
    @State var searchText: String = ""
    @State private var coordinator = SheetCoordinator<MemorySheet>()
    
    let allDetents: Set<PresentationDetent> = [.height(70), .height(350), .large]
    @State var selectedDetent: PresentationDetent = .height(350)
    
    @State var sheetHeight: CGFloat = 0
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
    
    func createMemoryDraft(at coordinate: CLLocationCoordinate2D) {
        selectedMemoryCoordinates = CoordinateWrapper(coordinate)
    }
    
    @ViewBuilder
    func BottomMapNavigationFloatingBar() -> some View {
        VStack(spacing: 20){
            Button {
                
            } label: {
                Image(systemName: "car.fill")
            }
            Button {
                
            } label: {
                Image(systemName: "location")
            }
        }
        .font(.system(size: 24, weight: .bold, design: .default))
        .foregroundStyle(.primary)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .glassEffect(.regular, in: .capsule)
    }
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(memories, id: \.id) { memory in
                        let coordinate = memory.coordinate
                        Annotation(
                            memory.title,
                            coordinate: coordinate
                        ) {
                            AnnotationPinButton(
                                memory: memory,
                                iconName: iconName(for:),
                                coordinator: coordinator
                            )
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
                            memory: nil
                        )
                        coordinator.presentSheet(.memoryForm, context: context)
                    }
                }
                .sheet(isPresented: $showBottomMapNavigationSheet) {
                    BottomMapNavigationSheet(coordinator: coordinator)
                        .presentationDetents(allDetents, selection: $selectedDetent)
                        .presentationBackgroundInteraction(.enabled)
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .sheetCoordinating(coordinator: coordinator)
                        .onGeometryChange(for: CGFloat.self) {
                            max(min($0.size.height, 350), 0)
                        } action: { newValue in
                            sheetHeight = newValue
                        }
                        
                }
                .overlay(alignment: .bottomTrailing) {
                    BottomMapNavigationFloatingBar()
                        .padding(.trailing, 15)
                        .offset(y: -sheetHeight)
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
            case .family: return "house.fill"
            case .entertainment: return "tv.fill"
            case .fitness: return "figure.run"
            case .shopping: return "cart.fill"
            case .nature: return "leaf.fill"
            case .culture: return "building.columns.fill"
            case .nightlife: return "moon.stars.fill"
            case .education: return "book.fill"
            case .health: return "heart.fill"
            case .adventure: return "figure.hiking"
            case .relaxation: return "sun.max.fill"
            case .pets: return "pawprint.fill"
            case .photography: return "camera.fill"
            case .music: return "music.note"
            case .art: return "paintpalette.fill"
            case .sports: return "sportscourt.fill"
            case .other: return "star.fill"
        }
    }
}


// MARK: - Annotation Pin Button Wrapper
private struct AnnotationPinButton: View {
    let memory: LocationMemory
    let iconName: (Category) -> String
    let coordinator: SheetCoordinator<MemorySheet>
    
    @State private var triggerWiggle = false
    
    var body: some View {
        Button {
            // Trigger wiggle animation
            triggerWiggle.toggle()
            
            // Small delay to let wiggle start, then open sheet
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
                iconName: iconName,
            )
        }
        .buttonStyle(.plain)
    }
}

struct BottomMapNavigationSheet: View {
    let coordinator: SheetCoordinator<MemorySheet>
    @State var searchText: String = ""
    
    var body: some View {
        ScrollView(.vertical){
            
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack (alignment: .leading) {
                
                HStack {
                    ZStack(alignment: .leading) {
                        TextField("Search maps" ,text: $searchText)
                            .padding(.vertical, 8)
                            .padding(.leading, 32)
                            .fontWeight(.medium)
                            .background(Color.gray.opacity(0.3), in: .capsule)
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .padding(8)
                    }
                    Button {
                        
                    } label: {
                        Circle()
                            .fill(Color.inputBG)
                            .frame(width: 35, height: 35)
                    }
                }
                
            }
            .padding(18)
        }
    }
}

#Preview {
    NavigationStack {
        MemoryMapView()
    }
}

