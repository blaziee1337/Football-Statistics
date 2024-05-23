//
//  LeagueSelectionViewModel.swift
//  GoalZone
//
//  Created by Halil Yavuz on 23.05.2024.
//

import Foundation

final class LeagueSelectionViewModel: ObservableObject {
    
    @Published var selectedLogo: String = ""
    @Published var selectedLeague: String = ""
    @Published var selectedLeagueID: Int = 0
    
    let leagues = [
        "Англия": ["Premier League", "Championship"],
        "Германия": ["Bundesliga", "2. Bundesliga"],
        "Испания": ["La Liga", "Segunda Division"],
        "Италия": ["Serie A", "Serie B"],
        "Франция": ["Ligue 1", "Ligue 2"]
    ]
    
    func selectLeague(_ league: String) {
        selectedLeague = league
        selectedLeagueID = getLeagueId(leagueName: league)
        selectedLogo = league.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    func getLeagueId(leagueName: String) -> Int {
        switch leagueName {
        case "Bundesliga":
            return 78
        case "2. Bundesliga":
            return 79
        case "Premier League":
            return 39
        case "Championship":
            return 40
        case "La Liga":
            return 140
        case "Segunda Division":
            return 141
        case "Serie A":
            return 135
        case "Serie B":
            return 136
        case "Ligue 1":
            return 61
        case "Ligue 2":
            return 4
        default:
            return 0
        }
    }
}
