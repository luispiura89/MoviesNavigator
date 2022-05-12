//
//  HTTPURLResponse+Make.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import Foundation

extension HTTPURLResponse {
    
    convenience init(code: Int) {
        self.init(url: URL(string: "https://any-url.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
}
