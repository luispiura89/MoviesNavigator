//
//  MockWindow.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 14/2/22.
//

import Foundation
import UIKit

final class MockWindow: UIWindow {
    
    private(set) var makeKeyAndVisibleCallCount = 0
    
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount += 1
    }
    
}
