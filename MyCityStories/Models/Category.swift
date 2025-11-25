//
//  Category.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 15/11/2025.
//

import Foundation
import SwiftUI

enum Category: String, CaseIterable, Codable {
    case food = "Food"
    case friends = "Friends"
    case travel = "Travel"
    case work = "Work"
    case family = "Family"
    case entertainment = "Entertainment"
    case fitness = "Fitness"
    case shopping = "Shopping"
    case nature = "Nature"
    case culture = "Culture"
    case nightlife = "Nightlife"
    case education = "Education"
    case health = "Health"
    case adventure = "Adventure"
    case relaxation = "Relaxation"
    case pets = "Pets"
    case photography = "Photography"
    case music = "Music"
    case art = "Art"
    case sports = "Sports"
    case other = "Other"
    
    var icon: String {
        switch self {
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
    
    var color: Color {
        switch self {
            case .food: return .orange
            case .friends: return .pink
            case .travel: return .purple
            case .work: return .indigo
            case .family: return .blue
            case .entertainment: return .red
            case .fitness: return .green
            case .shopping: return .cyan
            case .nature: return .mint
            case .culture: return .brown
            case .nightlife: return .purple
            case .education: return .yellow
            case .health: return .red
            case .adventure: return .orange
            case .relaxation: return .teal
            case .pets: return .brown
            case .photography: return .gray
            case .music: return .pink
            case .art: return .purple
            case .sports: return .blue
            case .other: return .gray
        }
    }
}
