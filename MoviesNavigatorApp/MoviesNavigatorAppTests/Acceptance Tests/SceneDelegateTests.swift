//
//  SceneDelegateTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 14/2/22.
//

import Foundation
@testable import MoviesNavigatorApp
import AuthenticationiOS
import XCTest
import Authentication
import SharedAPI
import TVShows

final class SceneDelegateTests: XCTestCase {
    
    func test_scene_makeWindowKeyAndVisible() {
        let exp = expectation(description: "wait for root")
        let window = MockWindow()
        let scene = SceneDelegate(httpClient: StubHTTPClient(), store: TokenStoreStub())
        scene.window = window
        window.onRootLoaded = {
            exp.fulfill()
        }
        scene.configure()
        wait(for: [exp], timeout: 3.0)
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
        XCTAssertTrue(window.rootViewController is LoginViewController)
    }
    
    private final class TokenStoreStub: TokenStore {
        func fetch(completion: @escaping FetchTokenCompletion) {
            completion(.failure(TokenStoreError.emptyStore))
        }
        
        func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion) {
            
        }
        
        func deleteToken(completion: @escaping TokenOperationCompletion) {
            
        }
        
        
    }
    
    private final class StubHTTPClient: HTTPClient {
        
        private struct Task: HTTPClientTask {
            func cancel() {
                
            }
        }
        
        func get(from url: URL, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask {
            Task()
        }
        
        func post(from url: URL, params: BodyParams, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask {
            Task()
        }
        
    }
    
}
