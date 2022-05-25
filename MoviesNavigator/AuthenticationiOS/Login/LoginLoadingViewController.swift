//
//  LoginLoadingViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 5/5/22.
//

import Foundation
import Authentication
import SharedPresentation
import UIKit

public final class LoginLoadingViewController: NSObject, LoadingView, LoginRequestSenderView {
    
    var view: UIButton {
        loginButton
    }

    public private(set) var isLoading = false {
        didSet {
            canSendRequest = !isLoading
            loginButton.setTitle(isLoading ? nil : "Log in", for: .normal)
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }

    public private(set) var canSendRequest = false {
        didSet {
            changeStatus(isEnabled: canSendRequest)
        }
    }
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()

    public private(set) lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        button.setTitle("Log in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .primaryGreen
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        
        button.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        return button
    }()
    
    public override init() {
        super.init()
        canSendRequest = false
        changeStatus(isEnabled: canSendRequest)
    }
    
    public func update(_ viewModel: LoginRequestSenderViewModel) {
        canSendRequest = viewModel.isEnabled
    }
    
    public func update(_ viewModel: LoadingViewModel) {
        isLoading = viewModel.isLoading
    }
    
    private func changeStatus(isEnabled: Bool) {
        loginButton.alpha = !isEnabled ? 0.5 : 1
        loginButton.isUserInteractionEnabled = isEnabled
    }
}
