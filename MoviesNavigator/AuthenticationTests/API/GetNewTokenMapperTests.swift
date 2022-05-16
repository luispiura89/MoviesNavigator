//
//  GetNewTokenMapperTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 9/5/22.
//

import Foundation
import XCTest
import Authentication

final class GetNewTokenMapperTests: XCTestCase {
    
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
            withData: try loginFailedResponse(),
            expectedError: .incorrectUserOrPassword
        )
    }
    
    func test_map_shouldDeliverNewTokenOn200HTTPResponseAndValidData() throws {
        let token = "any-token"
        let expirationDate = "2022-05-10 00:07:44 UTC"
        let sessionToken =
        try NewTokenRequestMapper.map(
            successfulHTTPResponseData(withToken: token, expirationDate: expirationDate),
            for: HTTPURLResponse(code: 200)
        )
        XCTAssertEqual(sessionToken.requestToken, token)
        XCTAssertEqual(sessionToken.expiresAt, expirationDate)
    }
    
    // MARK: - Helpers
    
    private func successfulHTTPResponseData(withToken token: String, expirationDate: String) throws -> Data {
        let json: [String: Any] = [
            "expires_at": expirationDate,
            "request_token": token,
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
            try NewTokenRequestMapper.map(data, for: HTTPURLResponse(code: code)),
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
