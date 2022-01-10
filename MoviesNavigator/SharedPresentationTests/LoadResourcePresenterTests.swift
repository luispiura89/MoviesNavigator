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

public struct ErrorViewModel {
    public let message: String
}

public protocol ErrorView {
    func update(_ viewModel: ErrorViewModel)
}

public class LoadResourcePresenter {
    
    private let loadingView: LoadingView
    private let errorView: ErrorView
    
    public static var generalError = "Something went wrong"
    
    public init(loadingView: LoadingView, errorView: ErrorView) {
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingResource() {
        loadingView.update(LoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.update(LoadingViewModel(isLoading: false))
        errorView.update(ErrorViewModel(message: LoadResourcePresenter.generalError))
    }
}

final class LoadResourcePresenterTests: XCTestCase {
    
    func test_startLoading_sendsStartLoadingMessageToView() {
        let (sut, viewSpy) = makeSUT()
        
        sut.didStartLoadingResource()
        
        XCTAssertEqual(viewSpy.messages, [.isLoading(true)])
    }
    
    func test_completeLoadingWithError_sendsErrorMessageToErrorView() {
        let viewSpy = ViewSpy()
        let error = anyError()
        let sut = LoadResourcePresenter(loadingView: viewSpy, errorView: viewSpy)
        
        sut.didFinishLoading(with: error)
        
        XCTAssertEqual(viewSpy.messages, [.isLoading(false), .error(LoadResourcePresenter.generalError)])
    }
    
    // MARK: - Helpers
    
    private final class ViewSpy: LoadingView, ErrorView {
        
        enum Message: Equatable {
            case isLoading(Bool)
            case error(String)
        }
        
        private(set) var messages = [Message]()
        
        func update(_ viewModel: LoadingViewModel) {
            messages.append(.isLoading(viewModel.isLoading))
        }
        
        func update(_ viewModel: ErrorViewModel) {
            messages.append(.error(viewModel.message))
        }
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LoadResourcePresenter, ViewSpy) {
        let viewSpy = ViewSpy()
        let sut = LoadResourcePresenter(loadingView: viewSpy, errorView: viewSpy)
        
        trackMemoryLeaks(sut, file: file, line: line)
        trackMemoryLeaks(viewSpy, file: file, line: line)
        
        return (sut, viewSpy)
    }
    
    private func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
    
    private func anyError() -> NSError {
        NSError(domain: "Error", code: 0, userInfo: nil)
    }
    
}
