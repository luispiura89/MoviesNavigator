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
        validateLaunchedViewController(
            store: TokenStoreStub.emptyTokenStore,
            validation: { viewController in
                viewController as? LoginViewController
            }
        )
    }
    
    func test_scene_rendersHomeWhenThereIsSession() {
        validateLaunchedViewController(
            store: TokenStoreStub.nonExpiredToken,
            validation: { viewController in
                viewController as? HomeViewController
            }
        )
    }
    
    func test_scene_rendersLoginWhenSessionHasExpired() {
        validateLaunchedViewController(
            store: TokenStoreStub.expiredToken,
            validation: { viewController in
                viewController as? LoginViewController
            }
        )
    }
    
    private func validateLaunchedViewController<T: UIViewController>(
        store: TokenStore,
        validation: @escaping (UIViewController?) -> T?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "wait for root")
        let window = MockWindow()
        let scene = SceneDelegate(httpClient: StubHTTPClient.alwaysSucceed, store: store)
        scene.window = window
        window.onRootLoaded = {
            exp.fulfill()
        }
        scene.configure()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, file: file, line: line)
        XCTAssertNotNil(
            validation(window.rootViewController),
            "Unexpected rendered view \(String(describing: window.rootViewController))",
            file: file,
            line: line
        )
    }
}
