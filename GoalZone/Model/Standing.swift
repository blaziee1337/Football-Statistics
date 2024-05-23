////
////  Team.swift
////  GoalZone
////
////  Created by Halil Yavuz on 11.05.2024.
////

import Foundation

struct StandingLeague: Codable {
   
    let response: [Response]
}

// MARK: - Response
struct Response: Codable {
    let league: League

}


// MARK: - League
struct League: Codable {
    let id: Int
    let name, country: String
    let logo, flag: String
    let season: Int
    let standings: [[Standing]]
}


// MARK: - Standing
struct Standing: Codable, Identifiable {
    let id = UUID()
    let rank: Int
    let team: Team
    let points, goalsDiff: Int
    let group, form, status, description: String?
    let all, home, away: Stats
    let update: String
}

// MARK: - All
struct Stats: Codable {
    let played: Int
    
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let name: String
    let logo: String
    
}
