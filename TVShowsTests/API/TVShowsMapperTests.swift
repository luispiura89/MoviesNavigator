//
//  TVShowsMapper.swift
//  TVShowsTests
//
//  Created by Luis Francisco Piura Mejia on 17/11/21.
//

import XCTest
import TVShows

final class TVShowsMapperTests: XCTestCase {
    
    func test_map_shouldThrowOnNon200HTTPResponse() throws {
        let invalidResponseCodes = [199, 300, 400, 499, 500]
        let invalidJSON = anyData()
        
        try invalidResponseCodes.forEach { code in
            try XCTAssertThrowsError(
                TVShowsMapper.map(
                    invalidJSON,
                    for: makeHTTPURLResponse(code: code)
                )
            )
        }
    }
    
    func test_map_shouldThrowOn200HTTPResponseAndInvalidData() throws {
        let invalidJSON = anyData()
        
        try XCTAssertThrowsError(
            TVShowsMapper.map(
                invalidJSON,
                for: makeHTTPURLResponse(code: 200)
            )
        )
    }
    
    func test_map_shouldThrowOn200HTTPResponseAndEmptyItemsList() {
        let emptyResultData = makeResultsJSON(page: 1, results: [])
        
        try XCTAssertThrowsError(
            TVShowsMapper.map(
                emptyResultData,
                for: makeHTTPURLResponse(code: 200)
            )
        )
    }
    
    func test_map_shouldReturnMappedItemsData() {
        let url = anyURL()
        let show0 = makeTVShow(id: 1, name: "a show", overview: "an overview", voteAverage: 3.0, firstAirDate: "2021-10-22", posterPath: url)
        let show1 = makeTVShow(id: 2, name: "another show", overview: "another overview", voteAverage: 9.9, firstAirDate: "2021-12-12", posterPath: url)
        let nonEmptyResultData = makeResultsJSON(page: 1, results: [show0.json, show1.json])
        
        XCTAssertEqual(try TVShowsMapper.map(nonEmptyResultData, for: makeHTTPURLResponse(code: 200)), [show0.model, show1.model])
    }
    
    // MARK: - Helpers
    
    private func makeTVShow(
        id: Int,
        name: String,
        overview: String,
        voteAverage: Double,
        firstAirDate: String,
        posterPath: URL?
    ) -> (model: TVShow, json: [String: Any]) {
        
        let model = TVShow(
            id: id,
            name: name,
            overview: overview,
            voteAverage: voteAverage,
            firstAirDate: firstAirDate,
            posterPath: posterPath)
        
        var json: [String: Any] = [:]
        json["id"] = model.id
        json["name"] = model.name
        json["overview"] = model.overview
        json["vote_average"] = model.voteAverage
        json["first_air_date"] = model.firstAirDate
        json["poster_path"] = posterPath?.absoluteString
        
        return (model, json.compactMapValues { $0 })
    }
    
    private func makeResultsJSON(page: Int, results: [[String: Any]]) -> Data {
        try! JSONSerialization.data(withJSONObject: [
            "page": page,
            "results": results
        ])
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("Invalid json".utf8)
    }
    
    private func makeHTTPURLResponse(code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}
