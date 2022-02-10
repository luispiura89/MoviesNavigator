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
    }
    
    case popular
    
    public func getURL(from baseURL: URL, withKey key: String) -> URL {
        var components = URLComponents(string: baseURL.absoluteString)
        switch self {
        case .popular:
            components?.path.append("popular")
            components?.queryItems = [URLQueryItem(name: Self.constants.apiKey, value: key)]
        }
        return components?.url ?? baseURL
    }
}
