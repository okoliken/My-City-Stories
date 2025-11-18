//
//  Category.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 15/11/2025.
//

import Foundation
import SwiftUI

enum Category: String, CaseIterable {
    case food = "Food"
    case friends = "Friends"
    case travel = "Travel"
    case work = "Work"
    case other = "Other"
    
    var icon: String {
        switch self {
            case .food: return "fork.knife"
            case .friends: return "person.2.fill"
            case .travel: return "airplane"
            case .work: return "briefcase.fill"
            case .other: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
            case .food: return .orange
            case .friends: return .pink
            case .travel: return .purple
            case .work: return .indigo
            case .other: return .gray
        }
    }
}
