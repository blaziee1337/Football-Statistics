//
//  LeagueSelection.swift
//  GoalZone
//
//  Created by Halil Yavuz on 16.05.2024.
//
import SwiftUI

struct LeagueSelectionView: View {
    @State private var selectedLeague: String?
    @State private var selectedLeagueId: Int?
    @State private var isLeagueSelected = false
    @StateObject private var viewModel = LeagueSelectionViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(viewModel.leagues.keys.sorted(), id: \.self) { country in
                    Section(header: Text(country)) {
                        ForEach(viewModel.leagues[country]!, id: \.self) { league in
                            leagueButton(for: league)
                        }
                    }
                }
            }
            .background(Color.black)
            .navigationTitle("Выбор лиги")
            .background(
                NavigationLink(
                    destination: LeagueDetailView().environmentObject(viewModel),
                    isActive: $isLeagueSelected,
                    label: { EmptyView() }
                )
            )
        }
    }
    
    private func leagueButton(for league: String) -> some View {
        Button(action: {
            viewModel.selectLeague(league)
            self.isLeagueSelected = true
        }) {
            HStack {
                Image(league.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 15)
                Text(league)
                    .foregroundColor(.white)
            }
        }
    }
}

struct LeagueSelection_Previews: PreviewProvider {
    static var previews: some View {
        LeagueSelectionView()
    }
}
