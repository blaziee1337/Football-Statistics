//
//  MainTabView.swift
//  GoalZone
//
//  Created by Halil Yavuz on 17.05.2024.
//

import SwiftUI

struct MainTabView: View {

@State private var selectedTab = 2

var body: some View {
    TabView(selection: $selectedTab) {
        NewsView()
            .tabItem {
                Label("News", systemImage: "newspaper")
                    
            }
            .tag(0)
        UpcomingMatchesView()
            .tabItem {
                Label("Matches", systemImage: "sportscourt.fill")
                    
            }
            .tag(1)
        LeagueSelectionView()
            .tabItem {
                Label("Statistics", systemImage: "trophy.fill")
                    
            }
            .tag(2)
    }
    
}
    
}

struct MainTabView_Previews: PreviewProvider {
static var previews: some View {
    MainTabView()
    }
    
}
