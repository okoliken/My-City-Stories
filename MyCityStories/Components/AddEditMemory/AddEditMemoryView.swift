//
//  AddEditMemoryView.swift
//  MyCityStories
//
//  Improved with Design System
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddEditMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - State Properties
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: Category = .other
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoImages: [UIImage] = []
    
    @State private var showingCamera = false
    @State private var showingCancelAlert = false
    @State private var isSaving = false
    
    // MARK: - Properties
    let latitude: Double
    let longitude: Double
    let isEditing: Bool
    var memory: LocationMemory? = nil
    
    var onCompletion: (Bool, LocalLocationMemory?) -> Void = { _, _ in }
    
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var hasChanges: Bool {
        !title.isEmpty || !note.isEmpty || !photoImages.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: DesignTokens.Spacing.xxl) {
                    // MARK: - Header Section
                    headerSection
                    
                    // MARK: - Photo Section
                    PhotoSection(
                        photoImages: $photoImages,
                        selectedPhotos: $selectedPhotos,
                        showingCamera: $showingCamera
                    )
                    
                    // MARK: - Form Content
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                        TitleField(title: $title)
                        NoteField(note: $note)
                        datePicker
                        CategoryPicker(selectedCategory: $selectedCategory)
                        LocationInfo(latitude: latitude, longitude: longitude)
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
                    }
                    
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveMemory()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.primary)
                           
                        }
                    }
                    .disabled(!canSave || isSaving)
                    
                }
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
            .onAppear {
                // Pre-populate fields if editing existing memory
                if let existingMemory = memory {
                    title = existingMemory.title
                    note = existingMemory.note ?? ""
                    selectedDate = existingMemory.date
                    selectedCategory = existingMemory.category
                    photoImages = existingMemory.photos
                }
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
            Text("Date")
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
        
        // Create or update memory in SwiftData
        let memoryToSave: LocationMemory
        if let existingMemory = memory {
            // Update existing memory
            existingMemory.title = title
            existingMemory.note = note.isEmpty ? nil : note
            existingMemory.date = selectedDate
            existingMemory.latitude = latitude
            existingMemory.longitude = longitude
            existingMemory.category = selectedCategory
            existingMemory.setPhotos(photoImages)
            existingMemory.updateModifiedDate()
            memoryToSave = existingMemory
        } else {
            // Create new memory
            let newMemory = LocationMemory(
                title: title,
                note: note.isEmpty ? nil : note,
                date: selectedDate,
                latitude: latitude,
                longitude: longitude,
                category: selectedCategory
            )
            newMemory.setPhotos(photoImages)
            modelContext.insert(newMemory)
            memoryToSave = newMemory
        }
        
        // Save to database
        do {
            try modelContext.save()
            isSaving = false
            
            // Convert to LocalLocationMemory for callback compatibility
            let locationMemory = LocalLocationMemory(from: memoryToSave)
            onCompletion(true, locationMemory)
            dismiss()
        } catch {
            isSaving = false
            print("Failed to save memory: \(error)")
            // Still call completion but with saved: false
            onCompletion(false, nil)
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
