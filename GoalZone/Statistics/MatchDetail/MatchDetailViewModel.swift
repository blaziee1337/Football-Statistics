//
//  MatchDetailViewModel.swift
//  GoalZone
//
//  Created by Halil Yavuz on 22.05.2024.
//

import Foundation
import Combine

final class MatchDetailViewModel: ObservableObject {
    @Published var homeTeamStatistics: TeamStatistics?
    @Published var awayTeamStatistics: TeamStatistics?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchMatchStatistics(fixtureID: Int) {
        StandingService.shared.fetchMatchStatistics(fixtureID: fixtureID)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching match statistics:", error)
                case .finished:
                    break
                }
            } receiveValue: { statisticsResponse in
                if statisticsResponse.response.count == 2 {
                    self.homeTeamStatistics = statisticsResponse.response[0]
                    self.awayTeamStatistics = statisticsResponse.response[1]
                }
                
            }
        
            .store(in: &cancellables)
    }
}


