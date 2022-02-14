//
//  SceneDelegateTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 14/2/22.
//

import Foundation
@testable import MoviesNavigatorApp
import XCTest

final class SceneDelegateTests: XCTestCase {
    
    func test_scene_makeWindowKeyAndVisible() {
        let window = MockWindow()
        let scene = SceneDelegate()
        scene.window = window
        
        scene.configure()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
    }
    
}
