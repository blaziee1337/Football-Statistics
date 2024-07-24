//
//  StandingViewModel.swift
//  GoalZone
//
//  Created by Halil Yavuz on 22.05.2024.
//

import Foundation
import Combine

//Observer
final class StandingViewModel: ObservableObject {
    var leagueID: Int
    var season: Int
    let networkService: StandingService
    //DI
    init(leagueID: Int, season: Int) {
        self.leagueID = leagueID
        self.season = season
        self.networkService = StandingService()
    }

    @Published var standings: [Standing] = []
    private var cancellables: Set<AnyCancellable> = []
    
   func fetchStandings() {
       networkService.fetchStanding(leagueID: leagueID, season: season)
      
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching Premier League data:", error)
                case .finished:
                    break
                }
            } receiveValue: { standingResponse in
                if let leagueStandings = standingResponse.response.first?.league.standings {
                    
                    self.standings = leagueStandings
                        .flatMap { $0 }
                    
                } else {
                    print("No standings data found")
                }
            }
            .store(in: &cancellables)
    }
}
