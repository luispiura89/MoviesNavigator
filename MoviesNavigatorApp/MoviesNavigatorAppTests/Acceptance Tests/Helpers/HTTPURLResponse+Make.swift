//
//  HTTPURLResponse+Make.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 3/6/22.
//

import Foundation

extension HTTPURLResponse {
    
    static var succesfulResponse: HTTPURLResponse {
        HTTPURLResponse(code: 200)
    }
    
    convenience init(code: Int) {
        self.init(
            url: URL(string: "https://any-url.com")!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
}
