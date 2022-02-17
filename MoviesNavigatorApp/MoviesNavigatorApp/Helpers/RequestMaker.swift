//
//  RequestMaker.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation
import SharedAPI
import TVShows

final class RequestMaker {
    
    private init() {}
    
    static func makeLoadShowsRequest(
        httpClient: HTTPClient,
        baseURL: URL,
        apiKey: String
    ) -> ((ShowsRequest) -> LoadShowsPublisher) {
        return { request in
            let endpoint: ShowsEndpoint
            switch request {
            case .popular:
                endpoint = .popular
            case .airingToday:
                endpoint = .airingToday
            case .onTV:
                endpoint = .onTV
            case .topRated:
                endpoint = .topRated
            }
            let url = endpoint.getURL(from: baseURL, withKey: apiKey)
            return httpClient
                .getPublisher(from: url)
                .tryMap(TVShowsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    static func makeLoadPosterRequest(
        httpClient: HTTPClient,
        imageBaseURL: URL
    ) -> ((URL) -> LoadShowPosterPublisher) {
        { posterPath in
            var baseURLComponents = URLComponents(string: imageBaseURL.absoluteString)
            baseURLComponents?.path.append(posterPath.lastPathComponent)
            return httpClient
                .getPublisher(from: baseURLComponents?.url ?? imageBaseURL)
                .tryMap(ImageDataMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
}
