import Foundation

struct TopScorersResponse: Codable {
    let response: [TopScorer]
}

struct TopScorer: Codable, Identifiable {
    let id = UUID()
    let player: PlayerDetails
    let statistics: [Statistic]
}

// MARK: - PlayerDetails
struct PlayerDetails: Codable {
    let age: Int
    let birth: Birth
    let firstname: String
    let height: String?
    let id: Int
    let injured: Bool
    let lastname: String
    let name: String
    let nationality: String
    let photo: String
    let weight: String?
}

// MARK: - Birth
struct Birth: Codable {
    let country: String
    let date: String
    let place: String?
}

// MARK: - Statistic
struct Statistic: Codable {
    let cards: Cards
    let dribbles: Dribbles
    let duels: Duels
    let fouls: Fouls
    let games: Games
    let goals: GoalsTopScorers
    let league: LeagueTopScorers
    let passes: Passes
    let penalty: Penalty
    let shots: Shots
    let team: TeamTopScorers
}

// MARK: - Cards
struct Cards: Codable {
    let red: Int?
    let yellow: Int?
    let yellowred: Int?
}

// MARK: - Dribbles
struct Dribbles: Codable {
    let attempts: Int?
    let past: Int?
    let success: Int?
}

// MARK: - Duels
struct Duels: Codable {
    let total: Int?
    let won: Int?
}

// MARK: - Fouls
struct Fouls: Codable {
    let committed: Int?
    let drawn: Int?
}

// MARK: - Games
struct Games: Codable {
    let appearences: Int?
    let captain: Bool?
    let lineups: Int?
    let minutes: Int?
    let number: Int?
    let position: String?
    let rating: String?
}

// MARK: - Goals
struct GoalsTopScorers: Codable {
    let assists: Int?
    let conceded: Int?
    let saves: Int?
    let total: Int?
}

// MARK: - League
struct LeagueTopScorers: Codable {
    let country: String?
    let flag: String?
    let id: Int?
    let logo: String?
    let name: String?
    let season: Int?
}

// MARK: - Passes
struct Passes: Codable {
    let accuracy: Int?
    let key: Int?
    let total: Int?
}

// MARK: - Penalty
struct Penalty: Codable {
    let commited: Int?
    let missed: Int?
    let saved: Int?
    let scored: Int?
    let won: Int?
}

// MARK: - Shots
struct Shots: Codable {
    let on: Int?
    let total: Int?
}

// MARK: - Team
struct TeamTopScorers: Codable {
    let id: Int?
    let logo: String?
    let name: String?
}
