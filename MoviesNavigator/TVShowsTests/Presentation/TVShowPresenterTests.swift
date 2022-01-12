//
//  TVShowPresenterTests.swift
//  TVShowsTests
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import TVShows
import XCTest

final class TVShowPresenterTests: XCTestCase {
    
    func test_map_shouldReturnViewModelsWithLocalizedDate() {
        let models = [
            TVShow(
                id: 0,
                name: "A Show",
                overview: "An Overview",
                voteAverage: 5.0,
                firstAirDate: "2021-01-13",
                posterPath: anyURL()),
            TVShow(
                id: 0,
                name: "Another Show",
                overview: "Another Overview",
                voteAverage: 6.1,
                firstAirDate: "2021-02-14",
                posterPath: anyURL())
        ]
        
        TVShowPresenter.locale = .current
        
        XCTAssertEqual(TVShowPresenter.map(models), [
            TVShowViewModel(
                name: "A Show",
                overview: "An Overview",
                voteAverage: "5.0",
                firstAirDate: "Jan 13, 2021"),
            TVShowViewModel(
                name: "Another Show",
                overview: "Another Overview",
                voteAverage: "6.1",
                firstAirDate: "Feb 14, 2021")
        ])
        
        TVShowPresenter.locale = Locale(identifier: "es")
        XCTAssertEqual(TVShowPresenter.map(models), [
            TVShowViewModel(
                name: "A Show",
                overview: "An Overview",
                voteAverage: "5.0",
                firstAirDate: "ene 13, 2021"),
            TVShowViewModel(
                name: "Another Show",
                overview: "Another Overview",
                voteAverage: "6.1",
                firstAirDate: "feb 14, 2021")
        ])
    }
    
}
