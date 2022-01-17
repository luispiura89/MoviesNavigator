//
//  LoadResourcePresenter.swift
//  SharedPresentation
//
//  Created by Luis Francisco Piura Mejia on 10/1/22.
//

import Foundation

public final class LoadResourcePresenter<InputResource, View: ResourceView> {
    
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
        errorView.update(.emptyError)
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
