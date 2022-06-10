//
//  UserInfoCell.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

import UIKit

public final class UserInfoCell: UICollectionViewCell {
    
    static let identifier = "UserInfoCell"
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "User Name"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .white
        return label
    }()
    
    private lazy var userHandleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@userhandle"
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .primaryGreen
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userAvatarImageView, userInfoStackView])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var userAvatarImageView = UserAvatarView()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userHandleLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        NSLayoutConstraint.activate(
            [
                mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45),
                trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 45),
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
