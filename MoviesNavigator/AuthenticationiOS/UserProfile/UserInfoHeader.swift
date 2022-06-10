//
//  UserInfoHeader.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

import UIKit

public final class UserInfoHeader: UICollectionReusableView {
    
    static let viewKind = "Header"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profile"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .primaryGreen
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
