//
//  AAAAA.swift
//  GoalZone
//
//  Created by Halil Yavuz on 19.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI


enum StatType: String, CaseIterable {
    case topScorers = "topscorers"
    case topAssists = "topassists"
    case topYellowCards = "topyellowcards"
    case topRedCards = "topredcards"
    
    var title: String {
        switch self {
        case .topScorers:
            return "Goals"
        case .topAssists:
            return "Assists"
        case .topYellowCards:
            return "Yellow Cards"
        case .topRedCards:
            return "Red Cards"
        }
    }
    
}
struct TopScorersView: View {
    @StateObject var viewModel: TopScorersViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(StatType.allCases, id: \.self) { statType in
                        createTopPlayersSection(statType: statType)
                    }
                }
                .padding()
            }
            
            .onAppear {
                viewModel.fetchPlayers(statType: .topScorers)
                viewModel.fetchPlayers(statType: .topAssists)
                viewModel.fetchPlayers(statType: .topYellowCards)
                viewModel.fetchPlayers(statType: .topRedCards)
            }
        }
    }
    
    private func createTopPlayersSection(statType: StatType) -> some View {
        let players = viewModel.players(for: statType)
        
        return VStack(alignment: .leading) {
            Text(statType.title)
                .font(.headline)
                .padding([.top, .leading, .trailing])
            
            VStack(alignment: .leading) {
                headerRow(statType: statType)
                
                ForEach(players.prefix(5)) { player in
                    PlayerRow(player: player, statType: statType)
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(color: Color.white.opacity(0.5), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
    
    private func headerRow(statType: StatType) -> some View {
        HStack {
            Text("Player")
                .padding(.horizontal, 20)
            
            Spacer()
            
            Text(statType.title)
                .padding(7)
        }
        .listRowBackground(Color.black)
        .padding(.vertical, 15)
    }
}

struct PlayerRow: View {
    let player: TopScorer
    let statType: StatType
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: player.player.photo))
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("\(player.player.firstname.components(separatedBy: " ").first ?? "") \(player.player.lastname)")
                Text("\(player.statistics.first?.games.position ?? "")")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            WebImage(url: URL(string: player.statistics.first?.league.flag ?? ""))
            
            switch statType {
            case .topScorers:
                Text("\(player.statistics.first?.goals.total ?? 0)")
            case .topAssists:
                Text("\(player.statistics.first?.goals.assists ?? 0)")
            case .topYellowCards:
                Text("\(player.statistics.first?.cards.yellow ?? 0)")
            case .topRedCards:
                Text("\(player.statistics.first?.cards.red ?? 0)")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct TopScorers_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TopScorersViewModel(leagueID: 78, season: 2023)
        TopScorersView(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}
