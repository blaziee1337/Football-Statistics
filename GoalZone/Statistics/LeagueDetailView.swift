//
//  LeagueDetailView.swift
//  GoalZone
//
//  Created by Halil Yavuz on 16.05.2024.
//

import SwiftUI
import Combine


struct LeagueDetailView: View {
    @EnvironmentObject var viewModel: LeagueSelectionViewModel
    @State private var selectedTab = 0
    @State private var selectedSeason = 0
    private let seasons = ["23/24", "22/23", "21/22"]
    private let seasonYears = [2023, 2022, 2021]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CustomNavigationBar(selectedSeason: $selectedSeason, selectedTab: $selectedTab, seasons: seasons)
            
            Spacer()
            
            Group {
                
                if selectedTab == 0 {
                    StandingsView(viewModel: StandingViewModel(leagueID: viewModel.selectedLeagueID, season: seasonYears[selectedSeason]))
                } else if selectedTab == 1 {
                    ResultsView(viewModel: ResultsViewModel(leagueID: viewModel.selectedLeagueID, season: seasonYears[selectedSeason]))
                } else if selectedTab == 2 {
                    TopScorersView(viewModel: TopScorersViewModel(leagueID: viewModel.selectedLeagueID, season: seasonYears[selectedSeason]))
                } else {
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: selectedTab)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .edgesIgnoringSafeArea(.top)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        }
    }
}

struct CustomNavigationBar: View {
    @EnvironmentObject var viewModel: LeagueSelectionViewModel
    @Binding var selectedSeason: Int
    @Binding var selectedTab: Int
    let seasons: [String]
    
    var body: some View {
        VStack(spacing: 25) {
            HStack(alignment: .center) {
                Spacer()
                Image(viewModel.selectedLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                Text(viewModel.selectedLeague)
                    .font(.title)
                    .lineLimit(1)
                Spacer()
                Picker("Сезон", selection: $selectedSeason) {
                    ForEach(seasons.indices, id: \.self) { index in
                        Text(seasons[index]).tag(index)
                        
                    }
                    
                }
                .frame(width: 100)
                .cornerRadius(8)
                Spacer()
            }
            .padding(.top, 70)
            .padding(.leading, 20)
            
            HStack(spacing: 0) {
                TabButton(title: "Таблица", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabButton(title: "Результаты", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabButton(title: "Лучшие игроки", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .background(leagueGradient(for: viewModel.selectedLeague))
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .foregroundColor(isSelected ? .blue : .white)
        }
    }
}

private func leagueGradient(for leagueName: String) -> some View {
    switch leagueName {
    case "Premier League":
        return LinearGradient(gradient: Gradient(colors: [Color(red: 56/255, green: 19/255, blue: 61/255), Color.purple, Color(red: 56/255, green: 19/255, blue: 61/255)]), startPoint: .leading, endPoint: .trailing)
    case "Bundesliga":
        return LinearGradient(gradient: Gradient(colors: [Color(red: 127/255, green: 35/255, blue: 33/255), Color.red.opacity(0.8), Color(red: 127/255, green: 35/255, blue: 33/255)]), startPoint: .leading, endPoint: .trailing)
    default:
        return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueDetailView()
            .environmentObject(LeagueSelectionViewModel())
    }
}
