//
//  ProfileSnapshotTests.swift
//  AuthenticationiOSTests
//
//  Created by Luis Francisco Piura Mejia on 9/6/22.
//

import XCTest
import AuthenticationiOS
import Authentication
import SharediOS

final class ProfileSnapshotTests: XCTestCase {
    
    func test_profile_rendersUserInfoAndAvatar() {
        let delegate = DelegateStub.alwaysSucceed
        let (sut, controller, showControllers) = makeSUT(withUserInfoDelegate: delegate)
        
        sut.setControllers([controller], forSection: 0)
        sut.setControllers(showControllers, forSection: 1)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_DARK")
    }
    
    func test_profile_rendersUserInfoAndLoadingAvatar() {
        let delegate = DelegateStub.alwaysLoading
        let (sut, controller, showControllers) = makeSUT(withUserInfoDelegate: delegate)
        
        sut.setControllers([controller], forSection: 0)
        sut.setControllers(showControllers, forSection: 1)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_LOADING_AVATAR_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_LOADING_AVATAR_DARK")
    }
    
    func test_profile_rendersUserInfoAndRetryActionAfterLoadingFail() {
        let delegate = DelegateStub.alwaysFailing
        let (sut, controller, showControllers) = makeSUT(withUserInfoDelegate: delegate)
        
        sut.setControllers([controller], forSection: 0)
        sut.setControllers(showControllers, forSection: 1)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "PROFILE_RETRY_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "PROFILE_RETRY_LOADING_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        withUserInfoDelegate delegate: DelegateStub
    ) -> (ProfileViewController, UserInfoViewController, [TVShowCellController]) {
        let controller = ProfileViewController()
        controller.loadViewIfNeeded()
        
        let userInfoController = UserInfoViewController(
            delegate: delegate,
            viewModel: UserInfoViewModel(
                userName: "Any User Name",
                userHandle: "@any-user-handle"
            )
        )
        let likedShowCell = TVShowCellController(
            viewModel: ("Any show", "Any overview", "June 15, 2022", "5.0"),
            delegate: delegate
        )
        let anotherLikedShowCell = TVShowCellController(
            viewModel: ("Another show", "Another overview", "June 15, 2022", "5.0"),
            delegate: delegate
        )
        let thirdLikedShowCell = TVShowCellController(
            viewModel: ("Third show", "Third overview", "June 15, 2022", "5.0"),
            delegate: delegate
        )
        let likedShowCells = [likedShowCell, anotherLikedShowCell, thirdLikedShowCell]
        delegate.controller = userInfoController
        delegate.tvShowCellController = likedShowCells
        return (controller, userInfoController, likedShowCells)
    }
    
    private final class DelegateStub: UserInfoViewControllerDelegate, TVShowCellControllerDelegate {
        
        weak var controller: UserInfoViewController?
        var tvShowCellController: [TVShowCellController]?
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
        
        func requestImage() {
            switch outcome {
            case .successful:
                tvShowCellController?.forEach { $0.setPosterImage(UIImage.make(withColor: .blue)) }
            case .loading:
                tvShowCellController?.forEach { $0.setLoadingState() }
            case .fail:
                tvShowCellController?.forEach { $0.setLoadingErrorState() }
            }
        }
        
        func cancelDownload() {}
        
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
