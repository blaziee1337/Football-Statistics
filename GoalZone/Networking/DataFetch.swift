//
//  DataFetch.swift
//  GoalZone
//
//  Created by Halil Yavuz on 12.05.2024.
//

import Foundation
import Alamofire
import Combine


final class StandingService {
    
    static let shared = StandingService()
    private let headers: HTTPHeaders = [
        "X-RapidAPI-Key": "YOUR API KEY",
        "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
    ]
    
    func fetchStanding(leagueID: Int, season: Int) -> AnyPublisher<StandingLeague, Error> {
        let url = "https://api-football-v1.p.rapidapi.com/v3/standings?season=\(season)&league=\(leagueID)"
        
        return Future<StandingLeague, Error> { promise in
            AF.request(url, headers: self.headers)
                .validate()
                .responseDecodable(of: StandingLeague.self) { response in
                    switch response.result {
                    case .success(let standingData):
                        promise(.success(standingData))
                        
                    case .failure(let error):
                        promise(.failure(error))
                        print("Error fetching standing data:", error)
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMatches(leagueID: Int, param: String) -> AnyPublisher<FixturesResponse, Error> {
        let url = "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=\(leagueID)&\(param)"
        return Future<FixturesResponse, Error> { promise in
            AF.request(url, headers: self.headers)
                .validate()
                .responseDecodable(of: FixturesResponse.self) { response in
                    switch response.result {
                    case .success(let fixtureData):
                        DispatchQueue.main.async {
                            promise(.success(fixtureData))
                           
                        }
                    case .failure(let error):
                        promise(.failure(error))
                        print("Error fetching matches data:", error)
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchTopScorers(param: String ,leagueID: Int, season: Int) -> AnyPublisher<TopScorersResponse, Error> {
        let url = "https://api-football-v1.p.rapidapi.com/v3/players/\(param)?league=\(leagueID)&season=\(season)"
        return Future<TopScorersResponse, Error> { promise in
            AF.request(url, headers: self.headers)
                .validate()
                .responseDecodable(of: TopScorersResponse.self) { response in
                    switch response.result {
                    case .success(let topScorersData):
                        DispatchQueue.main.async {
                            promise(.success(topScorersData))
                            
                        }
                    case .failure(let error):
                        promise(.failure(error))
                        print("Error fetching topScorers data:", error)
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMatchStatistics(fixtureID: Int) -> AnyPublisher<MatchStatisticsResponse, Error> {
        let url = "https://api-football-v1.p.rapidapi.com/v3/fixtures/statistics?fixture=\(fixtureID)"
        return Future<MatchStatisticsResponse, Error> { promise in
            AF.request(url, headers: self.headers)
                .validate()
                .responseDecodable(of: MatchStatisticsResponse.self) { response in
                    switch response.result {
                    case .success(let matchStatisticData):
                        DispatchQueue.main.async {
                            promise(.success(matchStatisticData))
                            
                        }
                    case .failure(let error):
                        promise(.failure(error))
                        print("Error fetching Statistics data:", error)
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
}

