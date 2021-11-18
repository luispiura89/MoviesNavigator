//
//  URLSessionHTTPClientTests.swift
//  SharedAPITests
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import XCTest
import SharedAPI

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_get_shouldDeliverErrorOnHTTPRequestError() {
        let error = anyNSError()
        URLProtocolStub.stub(with: error)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        let url = URL(string: "https://any-url.com")!
        
        var result: HTTPClient.GetResult?
        let exp = expectation(description: "Wait for get request")
        
        sut.get(from: url) { receivedResult in
            result = receivedResult
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        if case let .failure(receivedError as NSError) = result {
            XCTAssertEqual(receivedError.code, error.code)
        }
    }
    
    // MARK: - Helpers
    
    private func anyNSError() -> NSError {
        NSError(domain: "Any error", code: -1, userInfo: nil)
    }
    
    final class URLProtocolStub: URLProtocol {
        
        static var error: NSError?
        
        static func stub(with error: NSError) {
            URLProtocolStub.error = error
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            if let error = URLProtocolStub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
