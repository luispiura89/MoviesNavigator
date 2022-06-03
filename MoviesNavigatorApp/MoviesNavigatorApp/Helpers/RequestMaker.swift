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
    
    static func makeLoginRequest(
        httpClient: HTTPClient,
        baserURL: URL,
        apiKey: String,
        store: TokenStore
    ) -> LoginPublisherHandler {
        { user, password in
            let firstEndpoint: LoginEndpoint = .getNewToken
            let secondEndpoint: LoginEndpoint = .validateTokenWithLogin
            return httpClient
                .getPublisher(from: firstEndpoint.getURL(from: baserURL, apiKey: apiKey))
                .tryMap(NewTokenRequestMapper.map)
                .flatMap { result in
                    httpClient
                        .postPublisher(
                            from: secondEndpoint.getURL(from: baserURL, apiKey: apiKey),
                            params: secondEndpoint.getParameters(user, password, result.requestToken)!
                        )
                }
                .tryMap(NewTokenRequestMapper.map)
                .handleEvents(receiveOutput: { token in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
                    guard let date = formatter.date(from: token.expiresAt) else { return }
                    store.store(StoredToken(token: token.requestToken, expirationDate: date)) { _ in}
                })
                .eraseToAnyPublisher()
        }
    }
}
