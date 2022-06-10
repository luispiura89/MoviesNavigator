//
//  UserAvatarView.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

import UIKit

public final class UserAvatarView: UIImageView {
    
    var isLoading: Bool {
        set { newValue ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating() }
        get { loadingIndicator.isAnimating }
    }
    
    var loadingFailed: Bool {
        set { retryButton.isHidden = !newValue }
        get { !retryButton.isHidden }
    }
    
    private let imageSize: CGFloat = 125
    private let retryButtonSize: CGFloat = 50
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        return indicator
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setImage(.reload, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                button.widthAnchor.constraint(equalToConstant: retryButtonSize),
                button.heightAnchor.constraint(equalToConstant: retryButtonSize)
            ]
        )
        button.isHidden = true
        return button
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loadingIndicator)
        addSubview(retryButton)
        backgroundColor = .lightGray.withAlphaComponent(0.4)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                widthAnchor.constraint(equalToConstant: imageSize),
                heightAnchor.constraint(equalToConstant: imageSize),
                loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
                loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                retryButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
        clipsToBounds = true
        contentMode = .scaleAspectFill
        layer.cornerRadius = imageSize / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
