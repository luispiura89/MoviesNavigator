//
//  HomeScreenAcceptanceTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 14/2/22.
//

import Foundation
import Authentication
import XCTest
@testable import MoviesNavigatorApp
import TVShowsiOS
import TVShows
import SharedAPI

final class HomeScreenAcceptanceTests: XCTestCase {
    
    func test_app_shouldRenderHomeShowsForOnlineMode() {
        let sut = launch(client: StubHTTPClient(stub: makeSuccessfulResponse))
        
        XCTAssertEqual(sut.renderedCells(), 2)
        
        XCTAssertEqual(sut.name(at: 0), "First show")
        XCTAssertEqual(sut.overview(at: 0), "First overview")
        XCTAssertEqual(sut.voteAverage(at: 0), "5.0")
        XCTAssertEqual(sut.firstAirDate(at: 0), "Jan 15, 2022")
        XCTAssertEqual(sut.imageDataOnCell(at: 0), UIImage.make(withColor: .blue).pngData()!)
        
        XCTAssertEqual(sut.name(at: 1), "Second show")
        XCTAssertEqual(sut.overview(at: 1), "Second overview")
        XCTAssertEqual(sut.voteAverage(at: 1), "6.0")
        XCTAssertEqual(sut.firstAirDate(at: 1), "Jan 16, 2022")
        XCTAssertEqual(sut.imageDataOnCell(at: 1), UIImage.make(withColor: .blue).pngData()!)
    }
    
    // MARK: - Helpers
    
    private func launch(client: StubHTTPClient) -> HomeViewController {
        let scene = SceneDelegate(httpClient: client, store: TokenStoreStub.nonExpiredToken)
        scene.window = MockWindow()
        scene.configure()
        
        return scene.window?.rootViewController as! HomeViewController
    }
    
    private func makeSuccessfulResponse(for url: URL) -> HTTPClient.HTTPRequestResult {
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
                .succesfulResponse
            ))
        default:
            return .success((
                UIImage.make(withColor: .blue).pngData()!,
                .succesfulResponse
            ))
        }
    }
    
    private func makeTVShow(
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
    
    private func makeResultsJSON(page: Int, results: [[String: Any]]) -> Data {
        try! JSONSerialization.data(withJSONObject: [
            "page": page,
            "results": results
        ])
    }
    
}
