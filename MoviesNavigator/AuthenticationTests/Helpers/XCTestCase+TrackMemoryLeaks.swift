//
//  XCTestCase+TrackMemoryLeaks.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 24/5/22.
//

import XCTest

extension XCTestCase {
    
    func trackMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Potential memory leak for instance \(String(describing: instance))",
                file: file,
                line: line
            )
        }
    }

}
