//
//  XCTestCase+TrackMemoryLeaks.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 25/5/22.
//

import XCTest

extension XCTestCase {
    
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) stills in memory", file: file, line: line)
        }
    }

}
