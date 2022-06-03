//
//  StubHTTPClient.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import SharedAPI
import UIKit

final class StubHTTPClient: HTTPClient {
    
    private struct StubHTTPClientTask: HTTPClientTask {
        func cancel() {}
    }
    
    private var stub: (URL) -> HTTPRequestResult
    
    static var online: StubHTTPClient { StubHTTPClient(stub: Self.makeSuccessfulResponse) }
    
    init(stub: @escaping (URL) -> HTTPRequestResult) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask {
        completion(stub(url))
        return StubHTTPClientTask()
    }

    func post(from url: URL, params: BodyParams, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask {
        completion(stub(url))
        return StubHTTPClientTask()
    }
    
    private static func makeSuccessfulResponse(for url: URL) -> HTTPClient.HTTPRequestResult {
        let urlComponents = URLComponents(string: url.absoluteString)
        let host = urlComponents?.host ?? ""
        let path = urlComponents?.path ?? ""
        switch host {
        case "api.themoviedb.org" where path.contains("tv"):
            return .success((
                makeResultsJSON(page: 1, results: [
                    makeTVShow(
                        id: 0,
                        name: "First show",
                        overview: "First overview",
                        voteAverage: 5.0,
                        firstAirDate: "2022-01-15",
                        posterPath: URL(string: "https://image.tmdb.org/t/p/w1280/image-1.jpg")),
                    makeTVShow(
                        id: 1,
                        name: "Second show",
                        overview: "Second overview",
                        voteAverage: 6.0,
                        firstAirDate: "2022-01-16",
                        posterPath: URL(string: "https://image.tmdb.org/t/p/w1280/image-2.jpg"))
                ]),
                HTTPURLResponse(
                    url: URL(string: "https://any-url.com")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
            ))
        case "api.themoviedb.org" where path.contains("authentication/token/new") || path.contains("authentication/token/validate_with_login"):
            return .success((try! successfulHTTPResponseData(expirationDate: .distantFuture),
                 HTTPURLResponse(
                    url: URL(string: "https://any-url.com")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                 )!
                ))
        default:
            return .success((
                UIImage.make(withColor: .blue).pngData()!,
                HTTPURLResponse(
                    url: URL(string: "https://any-url.com")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
            ))
        }
    }
    
    private static func successfulHTTPResponseData(expirationDate: Date) throws -> Data {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let json: [String: Any] = [
            "expires_at": "2022-05-10 00:07:44 UTC",
            "request_token": "any-token",
            "success": true
        ]
        return try JSONSerialization.data(withJSONObject: json)
    }
    
    private static func makeTVShow(
        id: Int,
        name: String,
        overview: String,
        voteAverage: Double,
        firstAirDate: String,
        posterPath: URL?
    ) -> [String: Any] {
        
        var json: [String: Any] = [:]
        json["id"] = id
        json["name"] = name
        json["overview"] = overview
        json["vote_average"] = voteAverage
        json["first_air_date"] = firstAirDate
        json["poster_path"] = posterPath?.absoluteString
        
        return json.compactMapValues { $0 }
    }
    
    private static func makeResultsJSON(page: Int, results: [[String: Any]]) -> Data {
        try! JSONSerialization.data(withJSONObject: [
            "page": page,
            "results": results
        ])
    }
}