//
//  TopScorersViewModel.swift
//  GoalZone
//
//  Created by Halil Yavuz on 22.05.2024.
//

import Foundation
import Combine

final class TopScorersViewModel: ObservableObject {
  
    var leagueID: Int
    var season: Int
    init(leagueID: Int, season: Int) {
        self.leagueID = leagueID
        self.season = season
    }
    
    @Published var topScorers: [TopScorer] = []
    @Published var topAssists: [TopScorer] = []
    @Published var topYellowCards: [TopScorer] = []
    @Published var topRedCards: [TopScorer] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchPlayers(statType: StatType) {
        StandingService.shared.fetchTopScorers(param: statType.rawValue, leagueID: leagueID, season: season)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching \(statType.rawValue) data:", error)
                case .finished:
                    break
                }
            } receiveValue: { response in
                switch statType {
                case .topScorers:
                    self.topScorers = response.response
                case .topAssists:
                    self.topAssists = response.response
                case .topYellowCards:
                    self.topYellowCards = response.response
                case .topRedCards:
                    self.topRedCards = response.response
                }
            }
            .store(in: &cancellables)
    }
    
    func players(for statType: StatType) -> [TopScorer] {
        switch statType {
        case .topScorers:
            return topScorers
        case .topAssists:
            return topAssists
        case .topYellowCards:
            return topYellowCards
        case .topRedCards:
            return topRedCards
        }
    }
    
}
