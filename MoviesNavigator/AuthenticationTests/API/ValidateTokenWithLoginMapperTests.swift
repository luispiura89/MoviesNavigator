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
    
    func test_map_deliversErrorOnNon200HTTPResponse() {
        let response = [199, 300, 400, 404, 500]
        response.forEach {
            assertFailure(forResponseCode: $0, withData: anyData())
        }
    }
    
    func test_map_deliversErrorOn200HTTPResponseAndInvalidResponse() throws {
        assertFailure(forResponseCode: 200, withData: anyData())
        assertFailure(forResponseCode: 200, withData: try non200HTTPResponseData())
    }
    
    // MARK: - Helpers
    
    private func assertFailure(
        forResponseCode code: Int,
        withData data: Data,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(
            try ValidateTokenWithLoginMapper.map(data, for: HTTPURLResponse(code: code)),
            file: file,
            line: line
        ) { error in
            XCTAssertEqual(
                error as? AuthenticationError, AuthenticationError.invalidData,
                file: file,
                line: line
            )
        }
    }
    
}
