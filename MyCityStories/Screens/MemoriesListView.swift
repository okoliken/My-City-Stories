//
//  MemoriesListView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//
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

// MARK: - Main List View
struct MemoriesListView: View {
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    
    // Sample data - replace with your actual data source
    @State private var memories: [Memory] = [
        .init(title: "Pizza Night", note: "Best pizza in town!", date: Date(), category: .food, imageName: nil, latitude: 0, longitude: 0),
        .init(title: "Beach Day", note: "Amazing sunset", date: Date().addingTimeInterval(-86400), category: .travel, imageName: nil, latitude: 0, longitude: 0),
        .init(title: "Coffee with Sarah", note: "Caught up after months", date: Date().addingTimeInterval(-172800), category: .friends, imageName: nil, latitude: 0, longitude: 0),
        .init(title: "Project Launch", note: "Finally shipped!", date: Date().addingTimeInterval(-259200), category: .work, imageName: nil, latitude: 0, longitude: 0),
        .init(title: "Hidden Garden", note: "Found this peaceful spot", date: Date().addingTimeInterval(-345600), category: .other, imageName: nil, latitude: 0, longitude: 0)
    ]
    
    var filteredMemories: [Memory] {
        var filtered = memories
        
        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.note.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                if !memories.isEmpty {
                    CategoryFilterView(selectedCategory: $selectedCategory)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                
                // Memories Grid or Empty State
                if filteredMemories.isEmpty {
                    EmptyStateView(hasMemories: !memories.isEmpty)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(filteredMemories) { memory in
                                MemoryCardView(memory: memory)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Memories")
            .searchable(text: $searchText, prompt: "Search memories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Add new memory
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}





// MARK: - Preview
#Preview {
    MemoriesListView()
}
