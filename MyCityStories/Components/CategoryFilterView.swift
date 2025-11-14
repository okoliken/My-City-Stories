//
//  CategoryFilterView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import SwiftUI


struct CategoryFilterView: View {
    @Binding var selectedCategory: Category?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories chip
                FilterChip(
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil,
                    color: .blue
                ) {
                    selectedCategory = nil
                }
                
                // Individual category chips
                ForEach(Category.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}
