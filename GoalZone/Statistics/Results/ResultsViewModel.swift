//
//  ResultsViewModel.swift
//  GoalZone
//
//  Created by Halil Yavuz on 22.05.2024.
//

import Foundation
import Combine

final class ResultsViewModel: ObservableObject {
    
    var leagueID: Int
    var season: Int
    init(leagueID: Int, season: Int) {
        self.leagueID = leagueID
        self.season = season
    }

    @Published var fixtures: [Fixture] = []
  
    private var cancellables: Set<AnyCancellable> = []

    func fetchFixtures() {
        StandingService.shared.fetchMatches(leagueID: leagueID, param: "season=\(season)")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching fixtures data:", error)
                case .finished:
                    break
                }
            } receiveValue: { fixturesResponse in

                self.fixtures = fixturesResponse.response
            }
            .store(in: &cancellables)
    }
}

extension Fixture: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Fixture, rhs: Fixture) -> Bool {
        return lhs.id == rhs.id 
    }
}
