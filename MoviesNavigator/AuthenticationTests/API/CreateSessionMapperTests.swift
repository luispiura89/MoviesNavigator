//
//  CreateSessionMapperTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 14/6/22.
//

import Foundation
import Authentication
import XCTest

final class CreateSessionMapperTests: XCTestCase {
    
    func test_map_shouldThrowInvalidDataErrorForNon200HTTPResponse() {
        let errorCodes = [199, 300, 400, 500]
        
        errorCodes.forEach {
            assertFailure(forResponseCode: $0, withData: anyData())
        }
    }
    
    func test_map_shouldThrowInvalidDataErrorFor200HTTPResponseAndInvalidData() throws {
        assertFailure(forResponseCode: 200, withData: anyData())
        assertFailure(forResponseCode: 200, withData: try non200HTTPResponseData())
    }
    
    func test_map_shouldThrowUserErrorForNon200HTTPResponseOnLoginFailure() throws {
        assertFailure(
            forResponseCode: 401,
            withData: try non200HTTPResponseData(),
            expectedError: .invalidData
        )
    }
    
    func test_map_shouldDeliverNewTokenOn200HTTPResponseAndValidData() throws {
        let session = "any-id"
        let sessionToken =
        try CreateSessionMapper.map(
            successfulHTTPResponseData(withSession: session),
            for: HTTPURLResponse(code: 200)
        )
        XCTAssertEqual(sessionToken.id, session)
    }
    
    // MARK: - Helpers
    
    private func successfulHTTPResponseData(withSession session: String) throws -> Data {
        let json: [String: Any] = [
            "session_id": session,
            "success": true
        ]
        return try JSONSerialization.data(withJSONObject: json)
    }

    private func assertFailure(
        forResponseCode code: Int,
        withData data: Data,
        expectedError: AuthenticationError = AuthenticationError.invalidData,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(
            try CreateSessionMapper.map(data, for: HTTPURLResponse(code: code)),
            file: file,
            line: line
        ) { error in
            XCTAssertEqual(
                error as? AuthenticationError, expectedError,
                file: file,
                line: line
            )
        }
    }
    
}
