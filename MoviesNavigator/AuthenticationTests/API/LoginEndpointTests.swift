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
    case getNewToken
    
    public struct Constants {
        static let authentication = "authentication"
        static let token = "/token"
        static let new = "/new"
        static let validateWithLogin = "/validate_with_login"
        static let apiKey = "api_key"
        static let userName = "username"
        static let password = "password"
        static let requestToken = "request_token"
    }
    
    public func getURL(from baseURL: URL, apiKey: String) -> URL {
        var urlComponents = URLComponents(string: baseURL.absoluteString)
        
        urlComponents?.path.append(Constants.authentication)
        urlComponents?.path.append(Constants.token)
        switch self {
        case .validateTokenWithLogin:
            urlComponents?.path.append(Constants.validateWithLogin)
        case .getNewToken:
            urlComponents?.path.append(Constants.new)
        }
        
        urlComponents?.queryItems = [URLQueryItem(name: Constants.apiKey, value: apiKey)]
        
        return urlComponents?.url ?? baseURL
    }
    
    public func getParameters(_ params: String...) -> [String: Any]? {
        switch self {
        case .validateTokenWithLogin:
            guard params.count == 3 else { return nil }
            var bodyParams = [String: Any]()
            bodyParams[Constants.userName] = params[0]
            bodyParams[Constants.password] = params[1]
            bodyParams[Constants.requestToken] = params[2]
            return bodyParams
        default:
            return nil
        }
    }
}

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
