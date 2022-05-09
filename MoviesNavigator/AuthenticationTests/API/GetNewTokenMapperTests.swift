//
//  GetNewTokenMapperTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 9/5/22.
//

import Foundation
import XCTest

enum AuthenticationError: Error {
    case invalidData
}

public final class NewTokenRequestMapper {
    private struct CodableSessionToken: Codable {
        let expires_at: String
        let request_token: String
        
        var sessionToken: SessionToken {
            SessionToken(requestToken: request_token, expiresAt: expires_at)
        }
    }
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws -> SessionToken {
        guard response.statusCode == 200,
              let token = try? JSONDecoder().decode(CodableSessionToken.self, from: data).sessionToken else {
            throw AuthenticationError.invalidData
        }
        
        return token
    }
    
}

public struct SessionToken {
    public let requestToken: String
    public let expiresAt: String
}

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
    
    private func anyData() -> Data {
        Data("Any data".utf8)
    }
    
    private func non200HTTPResponseData() throws -> Data {
        let json: [String: Any] = [
            "status_code": 7,
            "status_message": "Any error message",
            "success": false
        ]
        return try JSONSerialization.data(withJSONObject: json)
    }
    
    private func successfulHTTPResponseData(withToken token: String, expirationDate: String) throws -> Data {
        let json: [String: Any] = [
            "expires_at": expirationDate,
            "request_token": token,
            "success": true
        ]
        return try JSONSerialization.data(withJSONObject: json)
    }
    
}

private extension HTTPURLResponse {
    
    convenience init(code: Int) {
        self.init(url: URL(string: "https://any-url.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
}
