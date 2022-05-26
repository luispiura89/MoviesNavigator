//
//  LoginMaker.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 26/5/22.
//

import Combine
import Authentication

final class LoginMaker: LoaderMaker {
    var requestType: Any? = nil
    
    func makeRequest() -> AnyPublisher<SessionToken, Error> {
        PassthroughSubject<SessionToken, Error>().eraseToAnyPublisher()
    }
}
