//
//  TVShowPresenter.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import Foundation

public struct TVShowViewModel: Equatable {
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
    
    public static func map(_ models: [TVShow], locale: Locale = .current) -> [TVShowViewModel] {
        models.map {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "YYYY-MM-dd"
            guard let firstAirDate = formatter.date(from: $0.firstAirDate) else {
                return TVShowViewModel(name: $0.name, overview: $0.overview, voteAverage: "\($0.voteAverage)", firstAirDate: "")
            }
            formatter.dateFormat = "MMM d, yyyy"
            let formattedDate = formatter.string(from: firstAirDate)
            return TVShowViewModel(name: $0.name, overview: $0.overview, voteAverage: "\($0.voteAverage)", firstAirDate: formattedDate)
        }
    }
    
}
