//
//  ImageDataMapperTests.swift
//  SharedAPITests
//
//  Created by Luis Francisco Piura Mejia on 16/2/22.
//

import Foundation
import XCTest
import SharedAPI

final class ImageDataMapperTests: XCTestCase {
    
    func test_map_shouldThrowForNon200HTTPResponse() throws {
        let non200ErrorCodes = [199, 300, 400, 404, 500]
        let invalidImageData = Data("any image data".utf8)
        
        try non200ErrorCodes.forEach {
            XCTAssertThrowsError(try ImageDataMapper.map(invalidImageData, for: HTTPURLResponse(code: $0)!))
        }
    }
    
    // MARK: - helpers
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
}
        
private extension HTTPURLResponse {
    
    convenience init?(code: Int) {
        self.init(
            url: URL(string: "https://any-url.com")!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)
    }
    
}
