//
//  Statistics.swift
//  GoalZone
//
//  Created by Halil Yavuz on 15.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct StandingsView: View {
    @StateObject var viewModel: StandingViewModel
    
    var body: some View {
        List {
            headerRow
                .listRowBackground(Color.black)
            
            ForEach(viewModel.standings) { standings in
                StandingRow(standings: standings)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.black)
        .onAppear {
            viewModel.fetchStandings()
        }
    }
    
    private var headerRow: some View {
        HStack {
            Text("#")
                .foregroundColor(.white)
            Text("Team")
                .foregroundColor(.white)
                .padding(.horizontal, 10)
            Spacer()
            Text("P")
                .foregroundColor(.white)
                .frame(alignment: .trailing)
                .padding(.horizontal, 13)
            Text("DIFF")
                .foregroundColor(.white)
                .frame(alignment: .trailing)
                .padding(.horizontal, 20)
            Text("Pts")
                .foregroundColor(.white)
        }
    }
}

struct StandingRow: View {
    var standings: Standing
    
    var body: some View {
        HStack {
            Text("\(standings.rank)")
                .padding(.horizontal, 5)
                .foregroundColor(.white)
            WebImage(url: URL(string: standings.team.logo))
                .resizable()
                .frame(width: 30, height: 30)
            Text("\(standings.team.name)")
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer()
            HStack(spacing: 30) {
                Text("\(standings.all.played)")
                    .foregroundColor(.white)
                    .frame(width: 30, alignment: .trailing)
                Text("\(standings.goalsDiff)")
                    .foregroundColor(.white)
                    .frame(width: 30, alignment: .trailing)
                Text("\(standings.points)")
                    .foregroundColor(.white)
                    .frame(width: 30, alignment: .trailing)
            }
        }
        .listRowBackground(Color.black)
        .padding(.vertical, 5)
    }
}


struct LeagueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StandingViewModel(leagueID: 78, season: 2023)
        StandingsView(viewModel: viewModel)
    }
}
