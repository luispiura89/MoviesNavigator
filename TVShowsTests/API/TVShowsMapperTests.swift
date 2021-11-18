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
        let data = Data("Invalid json".utf8)
        let url = URL(string: "https://any-url.com")!
        
        try invalidResponseCodes.forEach { code in
            try XCTAssertThrowsError(
                TVShowsMapper.map(
                    data,
                    for: HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
                )
            )
        }
    }
    
    func test_map_shouldThrowOn200HTTPResponseAndInvalidData() throws {
        let data = Data("Invalid json".utf8)
        let url = URL(string: "https://any-url.com")!
        
        try XCTAssertThrowsError(
            TVShowsMapper.map(
                data,
                for: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            )
        )
    }
    
    func test_map_shouldThrowOn200HTTPResponseAndEmptyItemsList() {
        let data = try! JSONSerialization.data(withJSONObject: [
            "page": 1,
            "results": []
        ])
        let url = URL(string: "https://any-url.com")!
        
        try XCTAssertThrowsError(
            TVShowsMapper.map(
                data,
                for: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            )
        )
    }
    
    func test_map_shouldReturnMappedItemsData() {
        let url = URL(string: "https://any-url.com")!
        let show0 = makeTVShow(id: 1, name: "a show", overview: "an overview", voteAverage: 3.0, posterPath: nil)
        let show1 = makeTVShow(id: 2, name: "another show", overview: "another overview", voteAverage: 9.9, posterPath: nil)
        let data = makeResultsJSON(page: 1, results: [show0.json, show1.json])
        
        XCTAssertEqual(try TVShowsMapper.map(data, for: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!), [show0.model, show1.model])
    }
    
    // MARK: - Helpers
    
    private func makeTVShow(
        id: Int,
        name: String,
        overview: String,
        voteAverage: Double,
        posterPath: URL?
    ) -> (model: TVShow, json: [String: Any]) {
        
        let model = TVShow(id: id, name: name, overview: overview, voteAverage: voteAverage, posterPath: posterPath)
        
        var json: [String: Any] = [:]
        json["id"] = model.id
        json["name"] = model.name
        json["overview"] = model.overview
        json["vote_average"] = model.voteAverage
        json["poster_path"] = posterPath?.absoluteString
        
        return (model, json.compactMapValues { $0 })
    }
    
    private func makeResultsJSON(page: Int, results: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "page": page,
            "results": results
        ])
    }
}
