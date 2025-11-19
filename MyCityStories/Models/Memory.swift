//
//  Memory.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import Foundation
import SwiftUI
import MapKit


// Local model to satisfy the dummy data and map annotations
struct LocationMemory: Identifiable {    
    var id: UUID
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
