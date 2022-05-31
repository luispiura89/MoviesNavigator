//
//  LoginEndpointTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 31/5/22.
//

import Authentication
import XCTest

public enum LoginEndpoint {
    case validateTokenWithLogin
    
    public struct Constants {
        static let authentication = "authentication"
        static let token = "/token"
        static let validateWithLogin = "/validate_with_login"
        static let apiKey = "api_key"
    }
    
    public func getURL(from baseURL: URL, apiKey: String) -> URL {
        var urlComponents = URLComponents(string: baseURL.absoluteString)
        
        urlComponents?.path.append(Constants.authentication)
        urlComponents?.path.append(Constants.token)
        urlComponents?.path.append(Constants.validateWithLogin)
        urlComponents?.queryItems = [URLQueryItem(name: Constants.apiKey, value: apiKey)]
        
        return urlComponents?.url ?? baseURL
    }
}

final class LoginEndpointTests: XCTestCase {
    
    func test_getURL_generatesValidURLForNewToken() {
        let baseURL = URL(string: "https://api.themoviedb.org/3/")!
        let apiKey = "123456789"
        let endpoint: LoginEndpoint = .validateTokenWithLogin
        
        let url = endpoint.getURL(from: baseURL, apiKey: apiKey)
        let components = URLComponents(string: url.absoluteString)
        
        XCTAssertEqual(components?.scheme, "https")
        XCTAssertEqual(components?.host, "api.themoviedb.org")
        XCTAssertEqual(components?.path, "/3/authentication/token/validate_with_login")
        XCTAssertEqual(components?.queryItems?.first?.name, "api_key")
        XCTAssertEqual(components?.queryItems?.first?.value, "123456789")
    }
    
}
