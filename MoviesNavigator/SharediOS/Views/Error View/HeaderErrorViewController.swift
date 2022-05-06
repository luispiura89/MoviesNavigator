//
//  HeaderErrorViewController.swift
//  SharediOS
//
//  Created by Luis Francisco Piura Mejia on 6/5/22.
//

import Foundation
import SharedPresentation
import UIKit

public final class HeaderErrorViewController: NSObject, ErrorView {

    public private(set) var errorView = HeaderErrorView(frame: .zero)
    
    public var error: String? {
        set { errorView.error = newValue }
        get { errorView.error }
    }
    
    public func pinErrorViewOnTop(ofView view: UIView) {
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: errorView.trailingAnchor).isActive = true
    }
    
    public func update(_ viewModel: ErrorViewModel) {
        error = viewModel.message
    }
}
