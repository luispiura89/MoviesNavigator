//
//  TVShowsMapper.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 17/11/21.
//

import Foundation

final public class TVShowsMapper {
    
    enum Error: Swift.Error {
        case connection
        case invalidData
    }
    
    static public func map(_ data: Data, for response: HTTPURLResponse) throws {
        throw Error.connection
    }
}
