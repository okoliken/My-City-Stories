//
//  ContentView.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 14/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            MapHomeView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            MemoriesListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
        }
    }
    
}


#Preview {
    ContentView()
}
