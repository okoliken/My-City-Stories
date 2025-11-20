//
//  AddEditMemoryView.swift
//  MyCityStories
//
//  Improved with Design System
//

import SwiftUI
import PhotosUI

struct AddEditMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State Properties
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: Category = .other
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoImage: Image?
    @State private var showingCamera = false
    @State private var showingCancelAlert = false
    @State private var isSaving = false
    
    // MARK: - Properties
    let latitude: Double
    let longitude: Double
    let isEditing: Bool
    

    var onCompletion: (Bool, LocationMemory?) -> Void = { _, _ in }
    
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var hasChanges: Bool {
        !title.isEmpty || !note.isEmpty || photoImage != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: DesignTokens.Spacing.xxl) {
                    // MARK: - Header Section
                    headerSection
                    
                    // MARK: - Photo Section
                    PhotoSection(
                        photoImage: $photoImage,
                        selectedPhoto: $selectedPhoto,
                        showingCamera: $showingCamera
                    )
                    
                    // MARK: - Form Content
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                        TitleField(title: $title)
                        NoteField(note: $note)
                        datePicker
                        CategoryPicker(selectedCategory: $selectedCategory)
                        LocationInfo(latitude: latitude, longitude: longitude)
                        
                        Button {
                            
                        } label: {
                            Text("Save Memory")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, DesignTokens.Spacing.lg)
            }
            .navigationTitle(isEditing ? "Edit Memory" : "Save Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        handleCancel()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.medium)
                    }
                    
                }
                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button {
//                        saveMemory()
//                    } label: {
//                        if isSaving {
//                            ProgressView()
//                                .tint(.white)
//                        } else {
//                            Text("Save")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                        }
//                    }
//                    .disabled(!canSave || isSaving)
//                   
//                }
            }
            .alert("Discard Changes?", isPresented: $showingCancelAlert) {
                Button("Keep Editing", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    onCompletion(false, nil)
                    dismiss()
                }
            } message: {
                Text("You have unsaved changes. Are you sure you want to discard them?")
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: "map.fill")
                .font(.system(size: 44))
                .foregroundStyle(
                    LinearGradient(
                        colors: [DesignTokens.Colors.primary, DesignTokens.Colors.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(DesignTokens.Spacing.md)
                .background(
                    Circle()
                        .fill(DesignTokens.Colors.primary.opacity(0.1))
                )
            
            Text(isEditing ? "Update Your Memory" : "Create a New Memory")
                .font(DesignTokens.Typography.title3)
                .fontWeight(.bold)
                .foregroundStyle(DesignTokens.Colors.textColorTheme)
            
            Text("Preserve this moment in time")
                .font(DesignTokens.Typography.subheadline)
                .foregroundStyle(DesignTokens.Colors.textColorTheme)
        }
        .padding(.top, DesignTokens.Spacing.xs)
    }
    
    // MARK: - Date Picker
    private var datePicker: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Label("Date", systemImage: "calendar")
                .sectionHeaderStyle()
            
            DatePicker(
                "Select date",
                selection: $selectedDate,
                in: ...Date(),
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            .labelsHidden()
        }
    }
    
    // MARK: - Actions
    private func handleCancel() {
        if hasChanges {
            showingCancelAlert = true
        } else {
            onCompletion(false, nil)
            dismiss()
        }
    }
    
    private func saveMemory() {
        isSaving = true
        
        // Simulate save delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isSaving = false
            
            let savedMemory = LocationMemory(
                id: UUID(),
                title: title,
                note: note,
                date: selectedDate,
                latitude: latitude,
                longitude: longitude,
                category: selectedCategory
            )
            
            onCompletion(true, savedMemory)
            dismiss()
        }
    }
}

// MARK: - Preview
#Preview {
    AddEditMemoryView(
        latitude: 37.7749,
        longitude: -122.4194,
        isEditing: false
    )
}
