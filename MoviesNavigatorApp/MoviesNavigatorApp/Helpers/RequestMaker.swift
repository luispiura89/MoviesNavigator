//
//  RequestMaker.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation
import SharedAPI
import TVShows
import Combine
import Authentication

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
                .tryMapWithErasure(mapper: TVShowsMapper.map)
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
                .tryMapWithErasure(mapper: ImageDataMapper.map)
        }
    }
    
    static func makeLoginRequest(
        httpClient: HTTPClient,
        baserURL: URL,
        apiKey: String,
        store: TokenStore
    ) -> LoginPublisherHandler {
        { [baserURL] user, password in
            let firstEndpoint: LoginEndpoint = .getNewToken
            let secondEndpoint: LoginEndpoint = .validateTokenWithLogin
            return httpClient
                .getPublisher(from: firstEndpoint.getURL(from: baserURL, apiKey: apiKey))
                .tryMapWithErasure(mapper: NewTokenRequestMapper.map)
                .validateToken(
                    from: secondEndpoint.getURL(from: baserURL, apiKey: apiKey),
                    httpClient: httpClient,
                    session: (user: user, password: password),
                    endpoint: secondEndpoint
                )
                .saveToken(store: store)
        }
    }
}
