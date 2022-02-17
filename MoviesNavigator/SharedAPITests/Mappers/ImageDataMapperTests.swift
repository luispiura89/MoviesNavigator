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
    
    func test_map_shouldThrowFor200HTTPResponseAndInvalidImageData() throws {
        let invalidImageData = Data("any image data".utf8)
        
        XCTAssertThrowsError(try ImageDataMapper.map(invalidImageData, for: HTTPURLResponse(code: 200)!))
    }
    
    func test_map_shouldReturnImageDataFor200HTTPResponseAndValidImageData() {
        let validImageData = validImageData()
        
        XCTAssertEqual(try ImageDataMapper.map(validImageData, for: HTTPURLResponse(code: 200)!), validImageData)
    }
    
    // MARK: - helpers
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func validImageData() -> Data {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.blue.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!.pngData()!
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
