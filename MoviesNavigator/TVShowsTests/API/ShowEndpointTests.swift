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
    
    private let baseURL = URL(string: "https://api.themoviedb.org/3/tv/")!
    private let apiKey = "123456789"
    
    func test_endpoint_generatesPopularShowsURL() {
        let sut: ShowsEndpoint = .popular
        
        let url = sut.getURL(from: baseURL, withKey: apiKey)
        
        let components = URLComponents(string: url.absoluteString)
        XCTAssertEqual(components?.path, "/3/tv/popular")
        XCTAssertEqual(components?.queryItems?.first?.value, apiKey)
        XCTAssertEqual(components?.queryItems?.first?.name, ShowsEndpoint.constants.apiKey)
    }
    
}
