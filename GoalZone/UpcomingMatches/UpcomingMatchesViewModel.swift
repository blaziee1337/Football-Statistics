//
//  UpcomingMatchesViewModel.swift
//  GoalZone
//
//  Created by Halil Yavuz on 21.05.2024.
//

import Foundation
import Combine

final class UpcomingMatchesViewModel: ObservableObject { //Observer
    
    @Published var matches: [Int: [Fixture]] = [:]
    let networkService: StandingService
        
    private var cancellables: Set<AnyCancellable> = []
    //DI
    init() {
        self.networkService = StandingService()
    }
    func fetchFixtures(forLeagues leagues: [(id: Int, logo: String, name: String, maxRound: Int)]) {
        for league in leagues {
            networkService.fetchMatches(leagueID: league.id, param: "next=10")
                .receive(on: DispatchQueue.main)
                .sink {  completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching fixtures data:", error)
                    case .finished:
                        break
                    }
                } receiveValue: { fixturesResponse in
                    self.matches[league.id] = fixturesResponse.response
                }
                .store(in: &cancellables)
        }
    }
}
