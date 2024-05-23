//
//  FixtureStatistics.swift
//  GoalZone
//
//  Created by Halil Yavuz on 20.05.2024.
//

import Foundation

struct MatchStatisticsResponse: Codable {
    let response: [TeamStatistics]
}

struct TeamStatistics: Codable {
    let team: TeamStatistic
    let statistics: [MatchStatistic]
}

struct TeamStatistic: Codable {
    let id: Int
    let name: String
    let logo: String
}

struct MatchStatistic: Codable {
    let type: String
    let value: StatisticValue
}

enum StatisticValue: Codable {
    case string(String)
    case int(Int)
    case none
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .none
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .none:
            try container.encodeNil()
        }
    }
}

