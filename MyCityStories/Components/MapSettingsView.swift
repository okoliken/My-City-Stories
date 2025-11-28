//
//  MapSettingsView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 26/11/2025.
//

import SwiftUI

struct MapSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedMapType = "Standard"
    @State private var selectedTheme = "System"
    @AppStorage("AppTheme") var appTheme: AppTheme = .systemDefault
    
    let mapTypes = ["Standard", "Satellite", "Hybrid"]
    
    var body: some View {
        NavigationView {
            List {
                // Map View Section
                Section {
                    ForEach(mapTypes, id: \.self) { type in
                        Button {
                            selectedMapType = type
                        } label: {
                            HStack {
                                Text(type)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedMapType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue).bold()
                                }
                            }
                        }
                    }
                } header: {
                    Text("Map View")
                }
                
                // Theme Section
                Section {
                    ForEach(AppTheme.allCases, id: \.rawValue) { theme in
                        Button {
                            appTheme = theme
                        } label: {
                            HStack {
                                Text(theme.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                if appTheme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue).bold()
                                }
                            }
                        }
                    }
                } header: {
                    Text("Theme")
                }
                
                // Placeholder Section
                Section {
                    HStack {
                        Text("Coming Soon")
                            .foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("More Options")
                }
            }
            .navigationTitle("Map Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    Text("Main View")
        .sheet(isPresented: .constant(true)) {
            MapSettingsView()
        }
}
