//
//  TVShowsSnapshotTests.swift
//  TVShowsiOSTests
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import XCTest
import TVShowsiOS

final class TVShowsSnapshotTests: XCTestCase {
    
    func test_tvShows_withContent() {
        let sut = TVShowsViewController()
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "TV_SHOWS_WITH_CONTENT_light")
    }
    
}
