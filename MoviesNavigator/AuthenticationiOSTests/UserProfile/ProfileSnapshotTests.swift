//
//  ProfileSnapshotTests.swift
//  AuthenticationiOSTests
//
//  Created by Luis Francisco Piura Mejia on 9/6/22.
//

import XCTest
import AuthenticationiOS
import Authentication

final class ProfileSnapshotTests: XCTestCase {
    
    func test_profile_rendersUserInfoAndAvatar() {
        let delegate = DelegateStub.alwaysSucceed
        let (sut, controller) = makeSUT(withUserInfoDelegate: delegate)
        
        sut.setControllers([controller])
        
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_LIGHT")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_DARK_LIGHT")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        withUserInfoDelegate userInfoDelegate: DelegateStub
    ) -> (ProfileViewController, UserInfoViewController) {
        let controller = ProfileViewController()
        controller.loadViewIfNeeded()
        
        let userInfoController = UserInfoViewController(
            delegate: userInfoDelegate,
            viewModel: UserInfoViewModel(
                userName: "Any User Name",
                userHandle: "@any-user-handle"
            )
        )
        userInfoDelegate.controller = userInfoController
        return (controller, userInfoController)
    }
    
    private final class DelegateStub: UserInfoViewControllerDelegate {
        
        weak var controller: UserInfoViewController?
        private let outcome: RequestOutcome
        
        static var alwaysSucceed: DelegateStub {
            DelegateStub(outcome: .successful)
        }
        
        init(outcome: RequestOutcome) {
            self.outcome = outcome
        }
        
        enum RequestOutcome {
            case successful
        }
        
        func loadUserAvatar() {
            controller?.setUserAvatar(.make(withColor: .orange))
        }
        
    }
    
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
