//
//  TestHelpers.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import Foundation

func anyData() -> Data {
    Data("Any data".utf8)
}

func non200HTTPResponseData() throws -> Data {
    let json: [String: Any] = [
        "status_code": 7,
        "status_message": "Any error message",
        "success": false
    ]
    return try JSONSerialization.data(withJSONObject: json)
}

func loginFailedResponse() throws -> Data {
    let json: [String: Any] = [
        "status_code": 30,
        "status_message": "Any error message",
        "success": false
    ]
    return try JSONSerialization.data(withJSONObject: json)
}
