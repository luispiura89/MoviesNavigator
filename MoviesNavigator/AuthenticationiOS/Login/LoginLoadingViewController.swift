//
//  LoginLoadingViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 5/5/22.
//

import Foundation
import UIKit

public final class LoginLoadingViewController: NSObject {
    
    var view: UIButton {
        loginButton
    }

    public var isLoading = false {
        didSet {
            loginButton.alpha = isLoading ? 0.5 : 1
            loginButton.isUserInteractionEnabled = !isLoading
            loginButton.setTitle(isLoading ? nil : "Log in", for: .normal)
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()

    private lazy var loginButton: UIButton = {
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
}
