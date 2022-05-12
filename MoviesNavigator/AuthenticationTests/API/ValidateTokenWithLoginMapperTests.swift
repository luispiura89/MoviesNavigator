//
//  ValidateTokenWithLoginMapperTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import XCTest
import Authentication

final class ValidateTokenWithLoginMapper {
    
    static func map(_ data: Data, for response: HTTPURLResponse) throws {
        throw AuthenticationError.invalidData
    }
    
}

final class ValidateTokenWithLoginMapperTests: XCTestCase {
    
    func test_map_deliversErrorOnNon200HTTPResponse() throws {
        let response = [199, 300, 400, 404, 500]
        try response.forEach {
            XCTAssertThrowsError(
                try ValidateTokenWithLoginMapper.map(anyData(), for: HTTPURLResponse(code: $0))
            ) { error in
                XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
            }
        }
    }
    
    func test_map_deliversErrorOn200HTTPResponseAndInvalidResponse() throws {
        XCTAssertThrowsError(
            try ValidateTokenWithLoginMapper.map(anyData(), for: HTTPURLResponse(code: 200))
        ) { error in
            XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
        }

        XCTAssertThrowsError(
            try ValidateTokenWithLoginMapper.map(non200HTTPResponseData(), for: HTTPURLResponse(code: 200))
        ) { error in
            XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
        }
    }
    
}
