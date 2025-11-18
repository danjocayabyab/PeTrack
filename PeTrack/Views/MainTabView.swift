//
//  MainTabView.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Image(systemName: "house.fill"); Text("Dashboard") }
                .tag(0)

            MyPetsView()
                .tabItem { Image(systemName: "pawprint.fill"); Text("My Pets") }
                .tag(1)

            ScheduleView()
                .tabItem { Image(systemName: "calendar"); Text("Schedule") }
                .tag(2)

            ExpensesScreen()
                .tabItem { Image(systemName: "dollarsign.circle.fill"); Text("Expenses") }
                .tag(3)
        }
        .accentColor(.blue)
    }
}
