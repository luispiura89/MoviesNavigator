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
    
    public static func map(_ data: Data, for response: HTTPURLResponse) throws {
        throw AuthenticationError.invalidData
    }
    
}

final class GetNewTokenMapperTests: XCTestCase {
    
    func test_map_shouldThrowInvalidDataErrorForNon200() throws {
        let errorCodes = [199, 300, 400, 500]
        
        try errorCodes.forEach {
            XCTAssertThrowsError(try NewTokenRequestMapper.map(anyData(), for: HTTPURLResponse(code: $0)), "") { error in
                XCTAssertEqual(error as? AuthenticationError, AuthenticationError.invalidData)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func anyData() -> Data {
        Data("Any data".utf8)
    }
    
}

private extension HTTPURLResponse {
    
    convenience init(code: Int) {
        self.init(url: URL(string: "https://any-url.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
}
