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
        public let onTVPath = "on_the_air"
    }
    
    case popular
    case topRated
    case onTV
    
    public func getURL(from baseURL: URL, withKey key: String) -> URL {
        var components = URLComponents(string: baseURL.absoluteString)
        switch self {
        case .popular:
            components?.path.append(Self.constants.popularShowsPath)
        case .topRated:
            components?.path.append(Self.constants.topRatedShowsPath)
        case .onTV:
            components?.path.append(Self.constants.onTVPath)
        
        }
        components?.queryItems = [URLQueryItem(name: Self.constants.apiKey, value: key)]
        return components?.url ?? baseURL
    }
}
