//
//  TVShowPresenter.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import Foundation

public struct TVShowViewModel: Equatable, Hashable {
    public let name: String
    public let overview: String
    public let voteAverage: String
    public let firstAirDate: String
    
    public init(name: String, overview: String, voteAverage: String, firstAirDate: String) {
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.firstAirDate = firstAirDate
    }
}

public final class TVShowPresenter {
    
    public static var locale: Locale = .current
    
    public static func map(_ models: [TVShow]) -> [TVShowViewModel] {
        models.map {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "YYYY-MM-dd"
            let overview = $0.overview.isEmpty ? "No provided overview" : $0.overview
            guard let firstAirDate = formatter.date(from: $0.firstAirDate) else {
                return TVShowViewModel(name: $0.name, overview: overview, voteAverage: "\($0.voteAverage)", firstAirDate: "")
            }
            formatter.dateFormat = "MMM d, yyyy"
            let formattedDate = formatter.string(from: firstAirDate)
            return TVShowViewModel(name: $0.name, overview: overview, voteAverage: "\($0.voteAverage)", firstAirDate: formattedDate)
        }
    }
    
}
