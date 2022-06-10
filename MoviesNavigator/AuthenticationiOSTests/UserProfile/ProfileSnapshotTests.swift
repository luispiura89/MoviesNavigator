//
//  ProfileSnapshotTests.swift
//  AuthenticationiOSTests
//
//  Created by Luis Francisco Piura Mejia on 9/6/22.
//

import XCTest
import AuthenticationiOS

final class ProfileSnapshotTests: XCTestCase {
    
    func test_profile_rendersUserInfo() {
        let sut = makeSUT()
        
        sut.setControllers([UserInfoViewController()])
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_LIGHT")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_DARK_LIGHT")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ProfileViewController {
        let controller = ProfileViewController()
        controller.loadViewIfNeeded()
        return controller
    }
    
}
