//
//  ResultsView.swift
//  GoalZone
//
//  Created by Halil Yavuz on 22.05.2024.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct ResultsView: View {
    @StateObject var viewModel: ResultsViewModel
    @State private var showingDetail = false
    @State private var selectedFixtureID: Int = 0
    @State private var selectedHomeScore: Int = 0
    @State private var selectedAwayScore: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                ForEach(matchesGroupedByRound().sorted { (round1, round2) -> Bool in
                    let num1 = extractRoundNumber(from: round1.0)
                    let num2 = extractRoundNumber(from: round2.0)
                    return num1 < num2
                }, id: \.0) { round in
                    Section(header: Text(round.0)
                        .font(.headline)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)) {
                            ForEach(round.1, id: \.self) { match in
                                matchRowWithoutArrow(match: match)
                            }
                        }
                }
            }
            .listRowBackground(Color.black)
            .listStyle(.plain)
            .onAppear {
                viewModel.fetchFixtures()
            }
            .fullScreenCover(isPresented: $showingDetail) {
                MatchDetailView(fixtureID: $selectedFixtureID, homeTeamScore: $selectedHomeScore, awayTeamScore: $selectedAwayScore)
            }
        }
    }
    
    private func formattedDate(from dateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd.MM yyyy"
        
        if let date = inputDateFormatter.date(from: dateString) {
            return outputDateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    private func leagueHeader() -> some View {
        HStack {
            Image("bundesliga")
                .resizable()
                .frame(width: 50, height: 50)
            Text("Бундеслига")
                .foregroundColor(.white)
            Spacer()
            Text("ТУР \(34)")
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
    
    private func matchRow(match: Fixture) -> some View {
        HStack {
            VStack {
                Text(formattedDate(from: match.fixture.date))
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(width: 60)
                    .lineLimit(2)
                    .padding(.vertical, 1)
                Text("\(match.fixture.status.short)")
                    .foregroundColor(Color.gray)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    WebImage(url: URL(string: match.teams.home.logo))
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text(match.teams.home.name)
                        .foregroundColor(colorForGoals(homeGoals: match.goals.home, awayGoals: match.goals.away, isHomeTeam: true))
                    
                    Spacer()
                    Text("\(match.goals.home ?? 0)")
                        .foregroundColor(colorForGoals(homeGoals: match.goals.home, awayGoals: match.goals.away, isHomeTeam: true))
                }
                .padding(.vertical, 2)
                
                HStack {
                    WebImage(url: URL(string: match.teams.away.logo))
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text(match.teams.away.name)
                        .foregroundColor(colorForGoals(homeGoals: match.goals.home, awayGoals: match.goals.away, isHomeTeam: false))
                    Spacer()
                    Text("\(match.goals.away ?? 0)")
                        .foregroundColor(colorForGoals(homeGoals: match.goals.home, awayGoals: match.goals.away, isHomeTeam: false))
                }
                .padding(.vertical, 2)
            }
            .padding(.leading, 15)
        }
        .padding(.vertical, 7)
    }
    
    private func colorForGoals(homeGoals: Int?, awayGoals: Int?, isHomeTeam: Bool) -> Color {
        guard let homeGoals = homeGoals, let awayGoals = awayGoals else {
            return .gray
        }
        
        if homeGoals == awayGoals {
            return .gray
        } else if (homeGoals > awayGoals && isHomeTeam) || (awayGoals > homeGoals && !isHomeTeam) {
            return .white
        } else {
            return .gray
        }
    }
    
    private func extractRoundNumber(from roundString: String) -> Int {
        let pattern = "\\d+$"
        if let range = roundString.range(of: pattern, options: .regularExpression) {
            return Int(roundString[range]) ?? 0
        }
        return 0
    }
    
    private func matchesGroupedByRound() -> [(String, [Fixture])] {
        var groupedMatches = [(String, [Fixture])]()
        
        for match in viewModel.fixtures {
            let roundNumber = extractRoundNumber(from: match.league.round)
            let roundKey = "Тур \(roundNumber)/\(34)"
            if let index = groupedMatches.firstIndex(where: { $0.0 == roundKey }) {
                groupedMatches[index].1.append(match)
            } else {
                groupedMatches.append((roundKey, [match]))
            }
        }
        
        return groupedMatches
    }
    
    private func matchRowWithoutArrow(match: Fixture) -> some View {
        Button(action: {
            self.selectedFixtureID = match.fixture.id
            self.selectedHomeScore = match.goals.home ?? 0
            self.selectedAwayScore = match.goals.away ?? 0
            self.showingDetail = true
        }) {
            matchRow(match: match)
                .background(Color.clear)
        }
    }
}


struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ResultsViewModel(leagueID: 78, season: 2023)
        ResultsView(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}



