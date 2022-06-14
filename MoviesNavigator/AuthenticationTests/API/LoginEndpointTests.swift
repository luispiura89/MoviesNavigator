//
//  LoginEndpointTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 31/5/22.
//

import Authentication
import XCTest

final class LoginEndpointTests: XCTestCase {
    
    func test_getURL_generatesValidURLForValidateToken() {
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
    
    func test_getURL_generatesValidBodyParamsForValidateToken() {
        let endpoint: LoginEndpoint = .validateTokenWithLogin
        
        let params = endpoint.getParameters("username", "password", "token")
        XCTAssertEqual(params?["username"] as? String, "username")
        XCTAssertEqual(params?["request_token"] as? String, "token")
    }

    func test_getURL_generatesValidURLForCreateSession() {
        let baseURL = URL(string: "https://api.themoviedb.org/3/")!
        let apiKey = "123456789"
        let endpoint: LoginEndpoint = .createSession
        
        let url = endpoint.getURL(from: baseURL, apiKey: apiKey)
        let components = URLComponents(string: url.absoluteString)
        
        XCTAssertEqual(components?.scheme, "https")
        XCTAssertEqual(components?.host, "api.themoviedb.org")
        XCTAssertEqual(components?.path, "/3/authentication/session/new")
        XCTAssertEqual(components?.queryItems?.first?.name, "api_key")
        XCTAssertEqual(components?.queryItems?.first?.value, "123456789")
    }

    func test_getURL_generatesValidBodyParamsForCreateSession() {
        let endpoint: LoginEndpoint = .createSession
        
        let params = endpoint.getParameters("token")
        XCTAssertEqual(params?["request_token"] as? String, "token")
    }
    
    func test_getURL_generatesInvalidBodyParamsForValidateTokenWithNotEnoughData() {
        let endpoint: LoginEndpoint = .validateTokenWithLogin
        
        XCTAssertNil(endpoint.getParameters("username"))
    }
    
    func test_getURL_generatesValidURLForNewToken() {
        let baseURL = URL(string: "https://api.themoviedb.org/3/")!
        let apiKey = "123456789"
        let endpoint: LoginEndpoint = .getNewToken
        
        let url = endpoint.getURL(from: baseURL, apiKey: apiKey)
        let components = URLComponents(string: url.absoluteString)
        
        XCTAssertEqual(components?.scheme, "https")
        XCTAssertEqual(components?.host, "api.themoviedb.org")
        XCTAssertEqual(components?.path, "/3/authentication/token/new")
        XCTAssertEqual(components?.queryItems?.first?.name, "api_key")
        XCTAssertEqual(components?.queryItems?.first?.value, "123456789")
    }
    
}
