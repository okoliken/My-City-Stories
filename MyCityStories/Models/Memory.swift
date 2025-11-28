//
//  Memory.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import Foundation
import MapKit
import SwiftUI
import SwiftData

// MARK: - SwiftData Model
@Model
final class LocationMemory {
    @Attribute(.unique) var id: UUID
    var title: String
    var note: String?
    var date: Date
    var latitude: Double
    var longitude: Double
    var category: Category
    var photoData: [Data]?
    var createdDate: Date
    var modifiedDate: Date
    var isFavorite: Bool = false
    
    init(
        id: UUID = UUID(),
        title: String,
        note: String? = nil,
        date: Date,
        latitude: Double,
        longitude: Double,
        category: Category,
        photoData: [Data]? = nil,
        createdDate: Date = Date(),
        modifiedDate: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        // Validate and limit photos to 5
        if let photos = photoData, photos.count > 5 {
            self.photoData = Array(photos.prefix(5))
        } else {
            self.photoData = photoData
        }
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.isFavorite = isFavorite
    }
    
    // MARK: - Computed Properties
    
    /// Converts photoData array to UIImage array for display
    var photos: [UIImage] {
        guard let photoData = photoData else { return [] }
        return photoData.compactMap { data in
            UIImage(data: data)
        }
    }
    
    /// Converts [UIImage] to [Data] for storage
    func setPhotos(_ images: [UIImage]) {
        let maxPhotos = min(images.count, 5)
        photoData = images.prefix(maxPhotos).compactMap { image in
            image.jpegData(compressionQuality: 0.8)
        }
        modifiedDate = Date()
    }
    
    /// Coordinate for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Updates modified date when properties change
    func updateModifiedDate() {
        modifiedDate = Date()
    }
}

// MARK: - Legacy Struct (for backward compatibility during transition)
struct LocalLocationMemory: Identifiable {
    var id: UUID
    let title: String
    let note: String? // optional so `nil` is allowed
    let date: Date
    let latitude: Double
    let longitude: Double
    let media: [UIImage]
    let category: Category
    
    /// Convert SwiftData LocationMemory to LocalLocationMemory struct
    init(from memory: LocationMemory) {
        self.id = memory.id
        self.title = memory.title
        self.note = memory.note
        self.date = memory.date
        self.latitude = memory.latitude
        self.longitude = memory.longitude
        self.media = memory.photos
        self.category = memory.category
    }
    
    /// Create LocationMemory directly
    init(
        id: UUID,
        title: String,
        note: String?,
        date: Date,
        latitude: Double,
        longitude: Double,
        media: [UIImage],
        category: Category
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.media = media
        self.category = category
    }
}

// MARK: - Coordinate Wrapper
struct CoordinateWrapper: Equatable {
    let latitude: Double
    let longitude: Double

    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }

    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
