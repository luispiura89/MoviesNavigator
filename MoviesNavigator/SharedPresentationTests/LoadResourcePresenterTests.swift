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

public struct ResourceViewModel<Resource> {
    public let resource: Resource
}

public protocol ResourceView {
    associatedtype Resource
    
    func update(_ viewModel: ResourceViewModel<Resource>)
}

public class LoadResourcePresenter<InputResource, View: ResourceView> {
    
    public typealias ResourceMapper = (InputResource) -> View.Resource
    
    private let loadingView: LoadingView
    private let errorView: ErrorView
    private let resourceView: View
    private let resourceMapper: ResourceMapper
    
    public let generalError = "Something went wrong"
    
    public init(loadingView: LoadingView, errorView: ErrorView, resourceView: View, resourceMapper: @escaping ResourceMapper) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.resourceView = resourceView
        self.resourceMapper = resourceMapper
    }
    
    public func didStartLoadingResource() {
        loadingView.update(LoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.update(LoadingViewModel(isLoading: false))
        errorView.update(ErrorViewModel(message: generalError))
    }
    
    public func didFinishLoading(with resource: InputResource) {
        loadingView.update(LoadingViewModel(isLoading: false))
        resourceView.update(ResourceViewModel(resource: resourceMapper(resource)))
    }
}

final class LoadResourcePresenterTests: XCTestCase {
    
    func test_startLoading_sendsStartLoadingMessageToView() {
        let (sut, viewSpy) = makeSUT()
        
        sut.didStartLoadingResource()
        
        XCTAssertEqual(viewSpy.messages, [.isLoading(true)])
    }
    
    func test_completeLoadingWithError_sendsErrorMessageToErrorView() {
        let (sut, viewSpy) = makeSUT()
        let error = anyError()
        
        sut.didFinishLoading(with: error)
        
        XCTAssertEqual(viewSpy.messages, [.isLoading(false), .error(sut.generalError)])
    }
    
    func test_completeLoadingWithResource_sendsSuccessfulMessageToResourceView() {
        let (sut, viewSpy) = makeSUT(resourceMapper: { resource in "\(resource) view model" })
        
        sut.didFinishLoading(with: "Any string")
        
        XCTAssertEqual(viewSpy.messages, [.isLoading(false), .resource("Any string view model")])
    }
    
    // MARK: - Helpers
    
    private final class ViewSpy: LoadingView, ErrorView, ResourceView {
        
        enum Message: Equatable {
            case isLoading(Bool)
            case error(String)
            case resource(String)
        }
        
        private(set) var messages = [Message]()
        
        func update(_ viewModel: LoadingViewModel) {
            messages.append(.isLoading(viewModel.isLoading))
        }
        
        func update(_ viewModel: ErrorViewModel) {
            messages.append(.error(viewModel.message))
        }
        
        func update(_ viewModel: ResourceViewModel<String>) {
            messages.append(.resource(viewModel.resource))
        }
    }
    
    private typealias StringResourcePresenter = LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(
        resourceMapper: @escaping StringResourcePresenter.ResourceMapper = { _ in "" },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (StringResourcePresenter, ViewSpy) {
        let viewSpy = ViewSpy()
        let sut = LoadResourcePresenter(loadingView: viewSpy, errorView: viewSpy, resourceView: viewSpy, resourceMapper: resourceMapper)
        
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
