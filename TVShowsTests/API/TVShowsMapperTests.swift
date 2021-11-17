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
    
}
