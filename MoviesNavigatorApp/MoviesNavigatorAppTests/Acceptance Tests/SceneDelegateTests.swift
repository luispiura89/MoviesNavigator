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
import TVShowsiOS

final class SceneDelegateTests: XCTestCase {
    
    func test_scene_rendersLoginWhenThereIsNoSession() {
        let exp = expectation(description: "wait for root")
        let window = MockWindow()
        let scene = SceneDelegate(httpClient: StubHTTPClient(), store: TokenStoreStub.emptyTokenStore)
        scene.window = window
        window.onRootLoaded = {
            exp.fulfill()
        }
        scene.configure()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
        XCTAssertTrue(window.rootViewController is LoginViewController)
    }
    
    func test_scene_rendersHomeWhenThereIsSession() {
        let exp = expectation(description: "wait for root")
        let window = MockWindow()
        let scene = SceneDelegate(httpClient: StubHTTPClient(), store: TokenStoreStub.nonExpiredToken)
        scene.window = window
        window.onRootLoaded = {
            exp.fulfill()
        }
        scene.configure()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
        XCTAssertTrue(window.rootViewController is HomeViewController)
    }
    
    func test_scene_rendersLoginWhenSessionHasExpired() {
        let exp = expectation(description: "wait for root")
        let window = MockWindow()
        let scene = SceneDelegate(httpClient: StubHTTPClient(), store: TokenStoreStub.expiredToken)
        scene.window = window
        window.onRootLoaded = {
            exp.fulfill()
        }
        scene.configure()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
        XCTAssertTrue(window.rootViewController is LoginViewController)
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
