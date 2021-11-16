//
//  TVShow.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 16/11/21.
//

public struct TVShow {
    public let id: Int
    public let name: String
    public let overview: String
    public let voteAverage: Double
    
    public init(id: Int, name: String, overview: String, voteAverage: Double) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
    }
}
