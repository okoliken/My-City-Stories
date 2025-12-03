# My City Stories - Project Structure

## Overview
This document describes the organized file structure of the My City Stories iOS app.

## Directory Structure

```
MyCityStories/
├── Assets.xcassets/          # App assets (colors, images, icons)
├── Components/               # Reusable UI components
│   ├── AddEditMemory/       # Memory creation/editing components
│   │   ├── AddEditMemoryView.swift
│   │   ├── CategoryPicker.swift
│   │   ├── LocationInfo.swift
│   │   ├── NoteField.swift
│   │   ├── PhotoSection.swift
│   │   └── TitleField.swift
│   ├── Map/                  # Map-related components
│   │   ├── AnnotationPinButton.swift
│   │   ├── BottomMapNavigationSheet.swift
│   │   ├── MapAnnotationPin.swift
│   │   └── MapSettingsView.swift
│   └── MemoryDetail/         # Memory detail view components
│       └── MemoryDetails.swift
├── Documentation/            # Project documentation
│   ├── PRD.txt              # Product Requirements Document
│   └── STRUCTURE.md         # This file
├── Models/                   # Data models
│   ├── Category.swift
│   └── Memory.swift
├── Styles/                   # Design system
│   └── DesignToken.swift
├── Utilities/                # Utility classes and helpers
│   └── SheetCoordinator.swift
├── Views/                    # Main view files
│   ├── ContentView.swift    # App entry view
│   └── MapHomeView.swift    # Main map view
└── MyCityStoriesApp.swift   # App entry point
```

## Organization Principles

1. **Components**: Grouped by feature/domain
   - `AddEditMemory/`: All components related to creating/editing memories
   - `Map/`: All map-related UI components
   - `MemoryDetail/`: Components for displaying memory details

2. **Views**: Main screen-level views
   - `ContentView.swift`: Root view that wraps the main app view
   - `MapHomeView.swift`: Primary map interface

3. **Models**: Data models using SwiftData
   - `Memory.swift`: LocationMemory model
   - `Category.swift`: Category enum

4. **Utilities**: Reusable utility classes
   - `SheetCoordinator.swift`: Handles sheet presentation logic

5. **Styles**: Design system tokens
   - `DesignToken.swift`: Centralized design tokens (colors, typography, spacing, etc.)

6. **Documentation**: Project documentation
   - `PRD.txt`: Product requirements
   - `STRUCTURE.md`: This structure document

## Notes

- All files are in the same Swift module, so explicit imports between files in the project are not required
- The Xcode project file (`.xcodeproj`) should be updated to reflect these file moves (Xcode typically handles this automatically)
- Follow MVVM architecture patterns as outlined in the project rules

