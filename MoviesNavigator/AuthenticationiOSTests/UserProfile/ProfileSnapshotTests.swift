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
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_DARK")
    }
    
    func test_profile_rendersUserInfoAndLoadingAvatar() {
        let delegate = DelegateStub.alwaysLoading
        let (sut, controller) = makeSUT(withUserInfoDelegate: delegate)
        
        sut.setControllers([controller])
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_LOADING_AVATAR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_LOADING_AVATAR_DARK")
    }
    
    func test_profile_rendersUserInfoAndRetryActionAfterLoadingFail() {
        let delegate = DelegateStub.alwaysFailing
        let (sut, controller) = makeSUT(withUserInfoDelegate: delegate)
        
        sut.setControllers([controller])
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_RETRY_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_RETRY_LOADING_DARK")
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
        
        static var alwaysLoading: DelegateStub {
            DelegateStub(outcome: .loading)
        }
        
        static var alwaysFailing: DelegateStub {
            DelegateStub(outcome: .fail)
        }
        
        init(outcome: RequestOutcome) {
            self.outcome = outcome
        }
        
        enum RequestOutcome {
            case successful
            case loading
            case fail
        }
        
        func loadUserAvatar() {
            switch outcome {
            case .successful:
                controller?.setUserAvatar(.make(withColor: .orange))
            case .loading:
                controller?.startLoading()
            case .fail:
                controller?.loadingFailed()
            }
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
