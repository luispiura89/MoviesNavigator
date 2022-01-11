//
//  ResourceView.swift
//  SharedPresentation
//
//  Created by Luis Francisco Piura Mejia on 10/1/22.
//

import Foundation


public struct ResourceViewModel<Resource> {
    public let resource: Resource
    
    public init(resource: Resource) {
        self.resource = resource
    }
}

public protocol ResourceView {
    associatedtype Resource
    
    func update(_ viewModel: ResourceViewModel<Resource>)
}
