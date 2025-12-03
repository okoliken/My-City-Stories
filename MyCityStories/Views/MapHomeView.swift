//
//  MapHomeView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import MapKit
import SwiftData
import SwiftUI

struct MemoryMapView: View {
    @Query(sort: \LocationMemory.createdDate, order: .reverse) private var memories:
        [LocationMemory]
    @State private var openNewpinSheet: Bool = false
    @State var showBottomMapNavigationSheet: Bool = true
    @State var selectedMemoryCoordinates: CoordinateWrapper? = nil
    @State var searchText: String = ""
    @State private var coordinator = SheetCoordinator<MemorySheet>()

    let allDetents: Set<PresentationDetent> = [.height(80), .height(400), .large]
    @State var selectedDetent: PresentationDetent = .height(400)

    @State var sheetHeight: CGFloat = 0
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 6.614378,
                longitude: 3.357768
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
        VStack(spacing: 20) {
            Button {
                coordinator.presentSheet(.mapSettings, context: nil)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Circle()
                            .stroke(.primary.opacity(0.1), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            Button {

            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(.blue.gradient)
                    )
                    .foregroundStyle(.white)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .glassEffect(.regular, in: .capsule)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
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
                    MapCompass()
                    MapScaleView()
                }
                .mapStyle(
                    .standard(
                        elevation: .realistic,
                        pointsOfInterest: .including([
                            .airport, .amusementPark, .animalService, .aquarium, .fireStation,
                            .bank,
                        ]),
                        showsTraffic: false
                    )
                )

                .mapControlVisibility(.visible)
                .gesture(
                    LongPressGesture()
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { value in
                            switch value {
                            case .second(true, let drag):
                                if let location = drag?.location,
                                    let coordinate = proxy.convert(location, from: .local)
                                {
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
                    ThemeSwitcher {
                        BottomMapNavigationSheet(
                            coordinator: coordinator,
                            selectedDetent: $selectedDetent
                        )
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

#Preview {
    NavigationStack {
        MemoryMapView()
    }
}
