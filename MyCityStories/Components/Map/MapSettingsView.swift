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

  var body: some View {
    NavigationView {
      List {

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
