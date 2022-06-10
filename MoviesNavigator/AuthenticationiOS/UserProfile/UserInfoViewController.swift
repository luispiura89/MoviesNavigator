//
//  UserInfoViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

import UIKit
import Authentication

public protocol UserInfoViewControllerDelegate {
    func loadUserAvatar()
}

public final class UserInfoViewController: NSObject, UICollectionViewDataSource {
    
    private var delegate: UserInfoViewControllerDelegate?
    private let viewModel: UserInfoViewModel
    
    public init(delegate: UserInfoViewControllerDelegate? = nil, viewModel: UserInfoViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    private var cell: UserInfoCell?
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        1
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserInfoCell.identifier,
            for: indexPath
        ) as? UserInfoCell
        cell?.userNameLabel.text = viewModel.userName
        cell?.userHandleLabel.text = viewModel.userHandle
        delegate?.loadUserAvatar()
        return cell!
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: UserInfoHeader.viewKind,
            withReuseIdentifier: UserInfoHeader.viewKind,
            for: indexPath
        )
    }
    
    public func setUserAvatar(_ avatar: UIImage) {
        cell?.userAvatarImageView.image = avatar
    }
    
    public func startLoading() {
        cell?.userAvatarImageView.isLoading = true
    }
    
    public func loadingFailed() {
        cell?.userAvatarImageView.loadingFailed = true
    }
}
