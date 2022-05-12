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
    
    func test_map_shouldThrowInvalidDataErrorForNon200HTTPResponse() throws {
        let errorCodes = [199, 300, 400, 500]
        
        try errorCodes.forEach {
            XCTAssertThrowsError(try NewTokenRequestMapper.map(anyData(), for: HTTPURLResponse(code: $0)), "") { error in
                XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
            }
        }
    }
    
    func test_map_shouldThrowInvalidDataErrorFor200HTTPResponseAndInvalidData() throws {
        XCTAssertThrowsError(try NewTokenRequestMapper.map(anyData(), for: HTTPURLResponse(code: 200)), "") { error in
            XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
        }
        XCTAssertThrowsError(
            try NewTokenRequestMapper.map(
                non200HTTPResponseData(),
                for: HTTPURLResponse(code: 200)
            ),
            ""
        ) { error in
            XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
        }
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
    
}
