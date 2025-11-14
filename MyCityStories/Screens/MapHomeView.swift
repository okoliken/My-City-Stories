//
//  MapHomeView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import SwiftUI
import MapKit


struct MapHomeView: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    //    let mapManager = CLLocationManager()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            Map(position: $cameraPosition) {
                Annotation("My Location",
                           coordinate:
                        .init(latitude: 4.8993134399999985, longitude: 7.030459879999998),
                content:  {
                    Image("my_profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 0.5)
                })
            }
            .colorScheme(.dark)
            .mapControls {
                MapUserLocationButton()
                
            }
            
        }
    }
}
