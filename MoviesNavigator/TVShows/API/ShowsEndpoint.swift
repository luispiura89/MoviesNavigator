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
        public let airingTodayPath = "airing_today"
        public let tv = "tv/"
    }
    
    case popular
    case topRated
    case onTV
    case airingToday
    
    public func getURL(from baseURL: URL, withKey key: String) -> URL {
        var components = URLComponents(string: baseURL.absoluteString)
        components?.path.append(Self.constants.tv)
        switch self {
        case .popular:
            components?.path.append(Self.constants.popularShowsPath)
        case .topRated:
            components?.path.append(Self.constants.topRatedShowsPath)
        case .onTV:
            components?.path.append(Self.constants.onTVPath)
        case .airingToday:
            components?.path.append(Self.constants.airingTodayPath)
        }
        components?.queryItems = [URLQueryItem(name: Self.constants.apiKey, value: key)]
        return components?.url ?? baseURL
    }
}
