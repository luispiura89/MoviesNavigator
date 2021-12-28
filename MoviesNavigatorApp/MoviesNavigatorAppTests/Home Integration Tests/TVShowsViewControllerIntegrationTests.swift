//
//  TVShowsViewControllerIntegrationTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 28/12/21.
//

import XCTest
import TVShowsiOS

final class TVShowsViewControllerIntegrationTests: XCTestCase {
    
    func test_tvShows_requestPopularShowsOnLoad() {
        let loadShowsSpy = LoadShowsSpy()
        let sut = TVShowsViewController(delegate: loadShowsSpy)
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loadShowsSpy.messages, [.loadPopularShows])
    }
    
    // MARK: - Helpers
    
    private final class LoadShowsSpy: TVShowsViewControllerDelegate {
        
        enum Message {
            case loadPopularShows
        }
        
        var messages = [Message]()
        
        func loadPopularShows() {
            messages.append(.loadPopularShows)
        }
    }
    
}
