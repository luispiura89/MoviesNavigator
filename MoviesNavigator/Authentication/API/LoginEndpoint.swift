//
//  LoginEndpoint.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 31/5/22.
//

import Foundation

public enum LoginEndpoint {
    case validateTokenWithLogin
    case getNewToken
    
    struct Constants {
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
