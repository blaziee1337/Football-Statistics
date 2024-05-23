////
////  Matches.swift
////  GoalZone
////
////  Created by Halil Yavuz on 16.05.2024.
////

import Foundation


struct FixturesResponse: Codable {
    
    let response: [Fixture]
    
}

struct Fixture: Codable, Identifiable {
    let id = UUID()
    let fixture: FixtureDetail
    let league: LeagueDetail
    let teams: FixtureTeams
    let goals: FixtureGoals
    let score: Score
    
}
struct FixtureDetail: Codable {
    let id: Int
    let referee: String?
    let timezone: String
    let date: String
    let timestamp: Int
    let periods: Periods
    let venue: Venue
    let status: Status
}
struct Periods: Codable {
    let first: Int?
    let second: Int?
}

struct Venue: Codable {
    let id: Int?
    let name: String?
    let city: String?
}

struct Status: Codable {
    let long: String
    let short: String
    let elapsed: Int?
}


struct LeagueDetail: Codable {
    let id: Int
    let name: String
    let country: String
    let logo: String
    let flag: String
    let season: Int
    let round: String
}

struct FixtureTeams: Codable {
    let home: FixtureTeam
    let away: FixtureTeam
}
struct FixtureTeam: Codable {
    let id: Int
    let name: String
    let logo: String
    let winner: Bool?
}


struct FixtureGoals: Codable {
    let home: Int?
    let away: Int?
}

struct Score: Codable {
    let halftime: Result
    let fulltime: Result
    let extratime: Result
    let penalty: Result
}
struct Result: Codable {
    let home: Int?
    let away: Int?
}




