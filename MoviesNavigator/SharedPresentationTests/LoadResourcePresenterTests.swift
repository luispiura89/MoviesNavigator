//
//  LoadResourcePresenterTests.swift
//  SharedPresentationTests
//
//  Created by Luis Francisco Piura Mejia on 10/1/22.
//

import Foundation
import XCTest

public struct LoadingViewModel {
    public let isLoading: Bool
}

public protocol LoadingView {
    func update(_ viewModel: LoadingViewModel)
}

public class LoadResourcePresenter {
    
    private let loadingView: LoadingView
    
    public init(loadingView: LoadingView) {
        self.loadingView = loadingView
    }
    
    public func didStartLoadingResource() {
        loadingView.update(LoadingViewModel(isLoading: true))
    }
    
}

final class LoadResourcePresenterTests: XCTestCase {
    
    func test_startLoading_sendsStartLoadingMessageToView() {
        let viewSpy = ViewSpy()
        let sut = LoadResourcePresenter(loadingView: viewSpy)
        
        sut.didStartLoadingResource()
        
        XCTAssertEqual(viewSpy.messages, [.isLoading(true)])
    }
    
    // MARK: - Helpers
    
    private final class ViewSpy: LoadingView {
        
        enum Message: Equatable {
            case isLoading(Bool)
        }
        
        private(set) var messages = [Message]()
        
        func update(_ viewModel: LoadingViewModel) {
            messages.append(.isLoading(viewModel.isLoading))
        }
    }
    
}
