//
//  ShowsEndpoint.swift
//  TVShows
//
//  Created by Luis Francisco Piura Mejia on 10/2/22.
//

import Foundation

public enum ShowsEndpoint {
    
    public static let constants = Constants()
    
    public struct Constants {
        public let apiKey = "api_key"
        public let popularShowsPath = "popular"
        public let topRatedShowsPath = "top_rated"
    }
    
    case popular
    case topRated
    
    public func getURL(from baseURL: URL, withKey key: String) -> URL {
        var components = URLComponents(string: baseURL.absoluteString)
        switch self {
        case .popular:
            components?.path.append(Self.constants.popularShowsPath)
        case .topRated:
            components?.path.append(Self.constants.topRatedShowsPath)
        }
        components?.queryItems = [URLQueryItem(name: Self.constants.apiKey, value: key)]
        return components?.url ?? baseURL
    }
}
