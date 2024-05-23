//
//  MatchDetailsView.swift
//  GoalZone
//
//  Created by Halil Yavuz on 20.05.2024.
//
//1048881

import SwiftUI
import SDWebImageSwiftUI


struct MatchDetailView: View {
    @ObservedObject private var viewModel = MatchDetailViewModel()
    @Binding  var fixtureID: Int
    @Binding var homeTeamScore: Int
    @Binding var awayTeamScore: Int
    
    var body: some View {
        
        CustomNavigationBarView(fixture: $fixtureID,
                                homeTeamScore: $homeTeamScore,
                                awayTeamScore: $awayTeamScore,
                                homeLogo: viewModel.homeTeamStatistics?.team.logo ?? "",
                                homeTeamName: viewModel.homeTeamStatistics?.team.name ?? "",
                                awayLogo: viewModel.awayTeamStatistics?.team.logo ?? "",
                                awayTeamName: viewModel.awayTeamStatistics?.team.name ?? "")
        
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let homeStats = viewModel.homeTeamStatistics?.statistics,
                       let awayStats = viewModel.awayTeamStatistics?.statistics {
                        ForEach(0..<homeStats.count, id: \.self) { index in
                            let homeStat = homeStats[index]
                            let awayStat = awayStats[index]
                            let maxValue = maxValues[homeStat.type] ?? 100.0
                            
                            VStack {
                                Text(homeStat.type)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                
                                HStack {
                                    VStack {
                                        Text(homeStat.value.displayValue())
                                            .font(.caption)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 15)
                                        ProgressView(value: min(max(homeStat.value.numericValue(maxValue: maxValue, type: homeStat.type), 0), 1), total: 1.0)
                                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                            .scaleEffect(x: -1, y: 1, anchor: .center)
                                            .frame(width: 150)
                                    }
                                    
                                    VStack {
                                        Text(awayStat.value.displayValue())
                                            .font(.caption)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .padding(.horizontal, 15)
                                        ProgressView(value: min(max(awayStat.value.numericValue(maxValue: maxValue, type: awayStat.type), 0), 1), total: 1.0)
                                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                            .frame(width: 150)
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.vertical, 30)
        
        .navigationBarBackButtonHidden(true)
        
        .edgesIgnoringSafeArea(.top)
        
        
        
        .onAppear {
            viewModel.fetchMatchStatistics(fixtureID: fixtureID)
            
        }
        
    }
    
    
}



struct CustomNavigationBarView: View {
    @ObservedObject var viewModel = MatchDetailViewModel()
    @Binding var fixture: Int
    @Binding var homeTeamScore: Int
    @Binding var awayTeamScore: Int
    var homeLogo: String
    var homeTeamName: String
    var awayLogo: String
    var awayTeamName: String
    @Environment(\.presentationMode) var presentationMode
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
            
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                backButton
                    .frame(alignment: .leading)
                
                VStack {
                    
                    WebImage(url: URL(string: homeLogo))
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(homeTeamName)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Text("\(homeTeamScore) - \(awayTeamScore)")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Spacer()
                VStack {
                    WebImage(url: URL(string: awayLogo))
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(awayTeamName)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 40)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .frame(height: 100)
    }
}



extension StatisticValue {
    func numericValue(maxValue: Double, type: String) -> Double {
        switch self {
        case .int(let value):
            return Double(value) / maxValue
        case .string(let value):
            
            if let intValue = Int(value.trimmingCharacters(in: CharacterSet(charactersIn: "%"))) {
                return Double(intValue) / 100.0
                
            } else if let intValue = Int(value) {
                return Double(intValue) / maxValue
            }
            return 0.0
        case .none:
            return 0.0
        }
    }
    
    func displayValue() -> String {
        switch self {
        case .int(let value):
            return "\(value)"
        case .string(let value):
            return value
        case .none:
            return "0"
        }
    }
}

let maxValues: [String: Double] = [
    "Shots on Goal": 20,
    "Shots off Goal": 15,
    "Total Shots": 30,
    "Blocked Shots": 15,
    "Shots insidebox": 15,
    "Shots outsidebox": 20,
    "Fouls": 30,
    "Corner Kicks": 15,
    "Offsides": 10,
    "Ball Possession": 100,
    "Yellow Cards": 10,
    "Red Cards": 5,
    "Goalkeeper Saves": 15,
    "Total passes": 1000,
    "Passes accurate": 1000,
    "Passes %": 100,
    "expected_goals": 100
]

