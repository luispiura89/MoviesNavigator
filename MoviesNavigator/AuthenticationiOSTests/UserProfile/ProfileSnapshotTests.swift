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
        assertInfoAndFavorites(
            screenData: makeSUT(withUserInfoDelegate: .alwaysSucceed),
            name: "PROFILE"
        )
    }
    
    func test_profile_rendersUserInfoAndLoadingAvatar() {
        assertInfoAndFavorites(
            screenData: makeSUT(withUserInfoDelegate: .alwaysLoading),
            name: "PROFILE_LOADING_AVATAR"
        )
    }
    
    func test_profile_rendersUserInfoAndRetryActionAfterLoadingFail() {
        assertInfoAndFavorites(
            screenData: makeSUT(withUserInfoDelegate: .alwaysFailing),
            name: "PROFILE_RETRY_LOADING"
        )
    }
    
    func test_profile_rendersUserInfoAndEmptyFavoriteShows() {
        let withFavorites = false
        assertInfoAndFavorites(
            screenData: makeSUT(withUserInfoDelegate: .alwaysSucceed, withFavorites: withFavorites),
            name: "PROFILE_WITH_INFO_AND_NO_FAVORITES",
            withFavorites: withFavorites
        )
    }
    
    // MARK: - Helpers
    
    private func assertInfoAndFavorites(
        screenData: (
            ProfileViewController,
            UserInfoViewController,
            [UICollectionViewDataSource],
            [UICollectionViewDataSource]
        ),
        name: String,
        withFavorites: Bool = true,
        recordSnapshot: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let (sut, controller, showControllers, headers) = screenData
        sut.setHeaders(headers)
        sut.setControllers([controller], forSection: 0)
        sut.setControllers(showControllers, forSection: 1)
        if !withFavorites {
            sut.updateForEmptyFavoriteShows()
        }
        
        if recordSnapshot {
            record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "\(name)_LIGHT", file: file, line: line)
            record(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "\(name)_DARK", file: file, line: line)
        } else {
            assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "\(name)_LIGHT", file: file, line: line)
            assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "\(name)_DARK", file: file, line: line)
        }
    }
    
    private func makeSUT(
        withUserInfoDelegate delegate: DelegateStub,
        withFavorites: Bool = true
    ) -> (ProfileViewController, UserInfoViewController, [UICollectionViewDataSource], [UICollectionViewDataSource]) {
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
        let controllers: [UICollectionViewDataSource] =
        withFavorites ? [likedShowCell, anotherLikedShowCell, thirdLikedShowCell] : [EmptyFavoritesShowCellController()]
        delegate.controller = userInfoController
        delegate.tvShowCellController = [likedShowCell, anotherLikedShowCell, thirdLikedShowCell]
        
        let headers: [UICollectionViewDataSource] = [UserInfoHeaderController(), UserFavoriteShowsHeaderController()]
        
        return (controller, userInfoController, controllers, headers)
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
