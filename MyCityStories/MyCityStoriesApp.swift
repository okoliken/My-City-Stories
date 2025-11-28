//
//  MyCityStoriesApp.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import SwiftUI
import SwiftData

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case systemDefault = "Default"
    
    var colorScheme: ColorScheme? {
        switch self {
            case .light: return .light
            case .dark: return .dark
            case .systemDefault: return nil
        }
    }
}

struct ThemeSwitcher<Content: View>: View {
    @ViewBuilder var content: Content
    @AppStorage("AppTheme") var theme: AppTheme = .systemDefault
    
    var body: some View {
        content
            .preferredColorScheme(theme.colorScheme)
    }
}



@main
struct MyCityStoriesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LocationMemory.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ThemeSwitcher {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
