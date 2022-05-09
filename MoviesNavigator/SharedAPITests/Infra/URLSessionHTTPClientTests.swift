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
        let sut = makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: nil, response: nil))
        
        let error = errorResult(for: sut) as NSError?
        
        XCTAssertEqual(error?.code, anyNSError().code)
    }
    
    func test_get_shouldDeliverRequestDataOnSuccessfulRequestAndValidHTTPURLResponse() {
        let sut = makeSUT(with: URLProtocolStub.Stub(error: nil, data: anyData(), response: anyHTTPURLResponse()))
        
        let result = successfulResult(for: sut)
        
        XCTAssertEqual(result?.data, anyData())
        XCTAssertEqual(result?.response.statusCode, anyHTTPURLResponse().statusCode)
        XCTAssertEqual(result?.response.url, anyHTTPURLResponse().url)
    }
    
    func test_get_shouldDeliverErrorForAllInvalidCases() {
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: nil, data: nil, response: nil))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: nil, data: anyData(), response: nil))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: nil, data: nil, response: anyNonHTTPURLResponse()))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: nil, data: anyData(), response: anyNonHTTPURLResponse()))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: anyData(), response: nil))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: nil, response: anyHTTPURLResponse()))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: nil, response: anyNonHTTPURLResponse()))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: anyData(), response: anyNonHTTPURLResponse()))))
        XCTAssertNotNil(errorResult(for: makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: anyData(), response: anyHTTPURLResponse()))))
    }
    
    func test_get_sendsRequestToProvidedURL() {
        let sut = makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: nil, response: nil))
        var url: URL?
        var method: String?
        URLProtocolStub.observeRequest = { request in
            url = request?.url
            method = request?.httpMethod
        }
        
        _ = resultFor(sut)
        
        XCTAssertEqual(url, anyURL())
        XCTAssertEqual(method, "GET")
    }
    
    func test_post_shouldDeliverErrorOnHTTPRequestError() {
        let sut = makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: nil, response: nil))
        
        let error = errorResult(for: sut, request: .post) as NSError?
        
        XCTAssertEqual(error?.code, anyNSError().code)
    }
    
    func test_post_sendsRequestToProvidedURL() {
        let sut = makeSUT(with: URLProtocolStub.Stub(error: anyNSError(), data: nil, response: nil))
        var url: URL?
        var method: String?
        var contentHeader: String?
        var bodyParams: [String: Any]?
        URLProtocolStub.observeRequest = { request in
            url = request?.url
            method = request?.httpMethod
            contentHeader = request?.value(forHTTPHeaderField: .contentType)
            if let httpBody = request?.httpBodyStream?.toData(),
               let json = try? JSONSerialization.jsonObject(with: httpBody, options: .fragmentsAllowed),
               let dict = json as? [String: Any] {
                bodyParams = dict
            }
        }
        
        _ = resultFor(sut, request: .post)
        
        XCTAssertEqual(url, anyURL())
        XCTAssertEqual(method, "POST")
        XCTAssertEqual(contentHeader, .applicationJSON)
        XCTAssertEqual(bodyParams?["key1"] as? String, "val1")
        XCTAssertEqual(bodyParams?["key2"] as? String, "val2")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(with stub: URLProtocolStub.Stub) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        URLProtocolStub.stub(with: stub)
        return URLSessionHTTPClient(session: session)
    }
    
    @discardableResult
    func successfulResult(for sut: HTTPClient, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let receivedResult = resultFor(sut)
        
        switch receivedResult {
        case let .success((receivedData, receivedResponse)):
            return (receivedData, receivedResponse)
        default:
            XCTFail("Expected succesful result got \(receivedResult) instead", file: file, line: line)
            return nil
        }
    }
    
    @discardableResult
    func errorResult(for sut: HTTPClient, request: Request = .get, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let receivedResult = resultFor(sut)
        
        switch receivedResult {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure got \(receivedResult) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(_ sut: HTTPClient, request: Request = .get) -> HTTPClient.GetResult {
        var receivedResult: HTTPClient.GetResult!
        let exp = expectation(description: "Wait for request")
        
        switch request {
        case .get:
            sut.get(from: anyURL()) { result in
                receivedResult = result
                exp.fulfill()
            }
        case .post:
            sut.post(from: anyURL(), params: ["key1": "val1", "key2": "val2"]) { result in
                receivedResult = result
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    enum Request {
        case get
        case post
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
        
        struct Stub {
            let error: NSError?
            let data: Data?
            let response: URLResponse?
        }
        
        static var observeRequest: ((URLRequest?) -> Void)?
        
        private static var stub: Stub?
        
        static func stub(with stub: Stub) {
            URLProtocolStub.stub = stub
        }
        
        static func removeStub() {
            stub = nil
            observeRequest = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            guard let stub = URLProtocolStub.stub else {
                return
            }
            
            if let observeRequest = URLProtocolStub.observeRequest {
                observeRequest(request)
                client?.urlProtocolDidFinishLoading(self)
                return
            }
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}

private extension String {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
}

extension InputStream {
    func toData() -> Data {
        var data = Data()
        open()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while hasBytesAvailable {
            let read = read(buffer, maxLength: bufferSize)
            data.append(buffer, count: read)
        }
        buffer.deallocate()
        close()
        return data
    }
}
