//
//  ShowEndpointTests.swift
//  TVShowsTests
//
//  Created by Luis Francisco Piura Mejia on 10/2/22.
//

import Foundation
import TVShows
import XCTest

final class ShowEndpointTests: XCTestCase {
    
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    private let apiKey = "123456789"
    
    func test_endpoint_generatesPopularShowsURL() {
        assert(endpointType: .popular, expectedPath: ShowsEndpoint.constants.popularShowsPath)
    }
    
    func test_endpoint_generatesTopRatedShowsURL() {
        assert(endpointType: .topRated, expectedPath: ShowsEndpoint.constants.topRatedShowsPath)
    }
    
    func test_endpoint_generatesOnTVShowsURL() {
        assert(endpointType: .onTV, expectedPath: ShowsEndpoint.constants.onTVPath)
    }
    
    func test_endpoint_generatesAiringTodayShowsURL() {
        assert(endpointType: .airingToday, expectedPath: ShowsEndpoint.constants.airingTodayPath)
    }
    
    // MARK: - Helpers
    
    private func assert(endpointType: ShowsEndpoint, expectedPath: String) {
        
        let url = endpointType.getURL(from: baseURL, withKey: apiKey)
        
        let components = URLComponents(string: url.absoluteString)
        XCTAssertEqual(components?.path, "/3/tv/\(expectedPath)")
        XCTAssertEqual(components?.queryItems?.first?.value, apiKey)
        XCTAssertEqual(components?.queryItems?.first?.name, ShowsEndpoint.constants.apiKey)
    }
    
}
