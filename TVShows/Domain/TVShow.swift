//
//  TVShow.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 16/11/21.
//

import Foundation

public struct TVShow: Hashable {
    public let id: Int
    public let name: String
    public let overview: String
    public let voteAverage: Double
    public let posterPath: URL?
    
    public init(id: Int, name: String, overview: String, voteAverage: Double, posterPath: URL?) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.posterPath = posterPath
    }
}
