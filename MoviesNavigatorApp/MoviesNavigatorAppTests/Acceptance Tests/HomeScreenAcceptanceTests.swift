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
        let sut = launch(client: .online)
        
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
    
}
