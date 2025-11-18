//
//  ContentView.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        MainTabView()
    }
}

#Preview { ContentView() }

