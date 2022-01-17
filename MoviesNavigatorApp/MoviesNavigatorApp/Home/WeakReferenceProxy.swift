//
//  WeakReferenceProxy.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import SharedPresentation

public final class WeakReferenceProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(instance: T) {
        self.instance = instance
    }
}

extension WeakReferenceProxy: ErrorView where T: ErrorView {
    public func update(_ viewModel: ErrorViewModel) {
        instance?.update(viewModel)
    }
}

extension WeakReferenceProxy: LoadingView where T: LoadingView {
    public func update(_ viewModel: LoadingViewModel) {
        instance?.update(viewModel)
    }
}
