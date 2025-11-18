//
//  Memory.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import Foundation

struct Memory: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let note: String
    let date: Date
    let category: Category
    let imageName: String? // For now, just store image name
    let latitude: Double
    let longitude: Double
}
