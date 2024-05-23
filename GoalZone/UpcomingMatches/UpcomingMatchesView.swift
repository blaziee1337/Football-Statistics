//
//  Matches.swift
//  GoalZone
//
//  Created by Halil Yavuz on 16.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpcomingMatchesView: View {
    
    @ObservedObject private var viewModel = UpcomingMatchesViewModel()
    
    private let leagues = [
        (id: 78, logo: "bundesliga" ,name: "BundesLiga", maxRound: 34),
        (id: 39, logo: "premierleague", name: "PremierLeague", maxRound: 38),
        (id: 140, logo: "laliga", name: "La Liga", maxRound: 38),
        (id: 135, logo: "seriea", name: "Serie A", maxRound: 38),
        (id: 61, logo: "ligue1", name: "Ligue 1", maxRound: 34)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(leagues, id: \.id) { league in
                    Section(header: LeagueHeaderView(league: league, currentRound: currentRound(for: league.id, maxRound: league.maxRound))) {
                        if let matches = viewModel.matches[league.id] {
                            ForEach(matches, id: \.fixture.id) { match in
                                MatchRowView(match: match)
                            }
                        } else {
                            Text("See ya in season 2024")
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
            .navigationTitle("Upcoming Matches")
            .onAppear {
                viewModel.fetchFixtures(forLeagues: leagues)
            }
        }
    }
    
    private func currentRound(for leagueID: Int, maxRound: Int) -> String {
        if let matches = viewModel.matches[leagueID], let firstMatch = matches.first {
            let currentRound = extractRoundNumber(from: firstMatch.league.round)
            return "ROUND \(currentRound) OF \(maxRound)"
        }
        return "ROUND 0/\(maxRound)"
    }
    
    private func extractRoundNumber(from roundString: String) -> String {
        let pattern = "\\d+$"
        if let range = roundString.range(of: pattern, options: .regularExpression) {
            return String(roundString[range])
        }
        return "Unknown Round"
    }
}

struct LeagueHeaderView: View {
    let league: (id: Int, logo: String, name: String, maxRound: Int)
    let currentRound: String
    
    var body: some View {
        HStack {
            Image(league.logo)
                .resizable()
                .frame(width: 50, height: 50)
            Text(league.name)
                .foregroundColor(.white)
            Spacer()
            Text(currentRound)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

struct MatchRowView: View {
    let match: Fixture
    
    var body: some View {
        HStack {
            Text(formattedDate(from: match.fixture.date))
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 60)
                .lineLimit(2)
            MatchTeamsView(homeTeam: match.teams.home, awayTeam: match.teams.away)
                .padding(.leading, 15)
        }
        .padding(.vertical, 7)
    }
    
    private func formattedDate(from dateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd.MM.yyyy"
        
        if let date = inputDateFormatter.date(from: dateString) {
            return outputDateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}

struct MatchTeamsView: View {
    let homeTeam: FixtureTeam
    let awayTeam: FixtureTeam
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WebImage(url: URL(string: homeTeam.logo))
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(homeTeam.name)
            }
            .padding(.vertical, 2)
            HStack {
                WebImage(url: URL(string: awayTeam.logo))
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(awayTeam.name)
            }
            .padding(.vertical, 2)
        }
    }
}

struct Matches_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingMatchesView()
    }
}
