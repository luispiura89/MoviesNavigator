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
    var onRootLoaded: (() -> Void)?
    
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount += 1
    }
    
    override var rootViewController: UIViewController? {
        didSet {
            onRootLoaded?()
        }
    }
    
}
