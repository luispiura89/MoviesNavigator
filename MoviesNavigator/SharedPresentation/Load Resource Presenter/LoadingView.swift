//
//  LoadingView.swift
//  SharedPresentation
//
//  Created by Luis Francisco Piura Mejia on 10/1/22.
//

import Foundation


public struct LoadingViewModel {
    public let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

public protocol LoadingView {
    func update(_ viewModel: LoadingViewModel)
}
