//
//  URLSessionHTTPClientTests.swift
//  SharedAPITests
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import XCTest
import SharedAPI

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func tearDown() {
        URLProtocolStub.removeStub()
    }
    
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
        } else {
            XCTFail("Expected \(error) got \(result) instead")
        }
    }
    
    func test_get_shouldDeliverRequestDataOnSuccessfulRequestAndValidHTTPURLResponse() {
        let requestData = anyData()
        URLProtocolStub.stub(with: requestData)
        URLProtocolStub.stub(with: anyHTTPURLResponse())
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
        
        if case let .success((receivedData, _)) = result {
            XCTAssertEqual(receivedData, requestData)
        } else {
            XCTFail("Expected \(requestData) got \(result) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func anyNSError() -> NSError {
        NSError(domain: "Any error", code: -1, userInfo: nil)
    }
    
    private func anyData() -> Data {
        Data("Any data".utf8)
    }
    
    private func anyNonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    final class URLProtocolStub: URLProtocol {
        
        private static var error: NSError?
        private static var data: Data?
        private static var response: URLResponse?
        
        static func stub(with error: NSError) {
            URLProtocolStub.error = error
        }
        
        static func stub(with data: Data) {
            URLProtocolStub.data = data
        }
        
        static func stub(with response: URLResponse) {
            URLProtocolStub.response = response
        }
        
        static func removeStub() {
            error = nil
            data = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            if let data = URLProtocolStub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = URLProtocolStub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = URLProtocolStub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
