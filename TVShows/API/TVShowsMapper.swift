//
//  TVShowsMapper.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 17/11/21.
//

import Foundation

final public class TVShowsMapper {
    
    private struct Root: Decodable {
        let page: Int
        let results: [Result]
        
        var shows: [TVShow] {
            results.map { TVShow(id: $0.id, name: $0.name, overview: $0.overview, voteAverage: $0.vote_average, posterPath: $0.poster_path) }
        }
    }
    
    private struct Result: Decodable {
        let id: Int
        let name: String
        let overview: String
        let vote_average: Double
        let poster_path: URL?
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static public func map(_ data: Data, for response: HTTPURLResponse) throws -> [TVShow] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data), !root.results.isEmpty else {
            throw Error.invalidData
        }
        
        return root.shows
    }
    
    
}
