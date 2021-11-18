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
        URLProtocolStub.stub(with: anyNSError())
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_get_shouldDeliverRequestDataOnSuccessfulRequestAndValidHTTPURLResponse() {
        let requestData = anyData()
        URLProtocolStub.stub(with: requestData)
        URLProtocolStub.stub(with: anyHTTPURLResponse())
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .success((anyData(), anyHTTPURLResponse())))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPClient(session: session)
    }
    
    private func expect(
        _ sut: HTTPClient,
        toCompleteWith expectedResult: HTTPClient.GetResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var receivedResult: HTTPClient.GetResult?
        let exp = expectation(description: "Wait for get request")
        
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        switch (expectedResult, receivedResult) {
        case let (.success((expectedData, _)), .success((receivedData, _))):
            XCTAssertEqual(expectedData, receivedData, file: file, line: line)
        case let (.failure(expectedError as NSError), .failure(receivedError as NSError)):
            XCTAssertEqual(expectedError.code, receivedError.code, file: file, line: line)
        default:
            XCTFail("Expected \(expectedResult) got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
    
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
