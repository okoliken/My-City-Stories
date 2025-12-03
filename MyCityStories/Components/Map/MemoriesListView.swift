//
//  MemoriesListView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import SwiftData
import SwiftUI

struct MemoriesListView: View {
  @Query(sort: \LocationMemory.createdDate, order: .reverse) private var allMemories: [LocationMemory]
  @State private var selectedCategory: Category? = nil
  @Environment(\.dismiss) private var dismiss
  
  let coordinator: SheetCoordinator<MemorySheet>
  
  private var filteredMemories: [LocationMemory] {
    if let category = selectedCategory {
      return allMemories.filter { $0.category == category }
    }
    return allMemories
  }
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        if !allMemories.isEmpty {
          categoryFilterSection
        }
        
        if filteredMemories.isEmpty {
          emptyStateView
        } else {
          memoriesList
        }
      }
      .navigationTitle("Memories")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .font(.system(size: 16, weight: .medium))
          }
        }
      }
    }
  }
  
  private var categoryFilterSection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        FilterButton(title: "All", isSelected: selectedCategory == nil) {
          selectedCategory = nil
        }
        
        ForEach(Category.allCases, id: \.self) { category in
          FilterButton(
            title: category.rawValue,
            isSelected: selectedCategory == category,
            color: category.color
          ) {
            selectedCategory = selectedCategory == category ? nil : category
          }
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .background(Color(.systemBackground))
  }
  
  private var memoriesList: some View {
    List {
      ForEach(filteredMemories) { memory in
        MemoryRow(memory: memory, coordinator: coordinator)
          .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
          .listRowBackground(Color.clear)
      }
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
  }
  
  private var emptyStateView: some View {
    VStack(spacing: 12) {
      Image(systemName: selectedCategory == nil ? "mappin.circle" : "tray")
        .font(.system(size: 44))
        .foregroundStyle(.secondary)
      
      Text(selectedCategory == nil ? "No Memories" : "No \(selectedCategory?.rawValue ?? "") Memories")
        .font(.title3)
        .fontWeight(.medium)
      
      Text(selectedCategory == nil 
           ? "Create your first memory by long-pressing on the map"
           : "Try a different category")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct FilterButton: View {
  let title: String
  let isSelected: Bool
  var color: Color = .blue
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.subheadline)
        .fontWeight(isSelected ? .semibold : .regular)
        .foregroundStyle(isSelected ? .white : .primary)
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(
          Capsule()
            .fill(isSelected ? color : Color(.secondarySystemBackground))
        )
    }
  }
}

struct MemoryRow: View {
  let memory: LocationMemory
  let coordinator: SheetCoordinator<MemorySheet>
  
  var body: some View {
    Button {
      coordinator.presentSheet(.memoryDetail, context: .init(memory: memory))
    } label: {
      HStack(spacing: 12) {
        if let photo = memory.photos.first {
          Image(uiImage: photo)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
          RoundedRectangle(cornerRadius: 8)
            .fill(memory.category.color.opacity(0.15))
            .frame(width: 70, height: 70)
            .overlay(
              Image(systemName: memory.category.icon)
                .foregroundStyle(memory.category.color)
            )
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text(memory.title)
            .font(.body)
            .fontWeight(.medium)
            .lineLimit(1)
          
          HStack(spacing: 6) {
            Text(memory.category.rawValue)
              .font(.caption)
              .foregroundStyle(memory.category.color)
            
            Text("•")
              .font(.caption)
              .foregroundStyle(.secondary)
            
            Text(formatDate(memory.createdDate))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(.system(size: 13))
          .foregroundStyle(.tertiary)
      }
    }
  }
  
  private func formatDate(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    
    if calendar.isDateInToday(date) {
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      return formatter.string(from: date)
    } else if calendar.isDateInYesterday(date) {
      return "Yesterday"
    } else {
      let daysAgo = calendar.dateComponents([.day], from: date, to: now).day ?? 0
      if daysAgo < 7 {
        return "\(daysAgo)d ago"
      } else {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
      }
    }
  }
}
