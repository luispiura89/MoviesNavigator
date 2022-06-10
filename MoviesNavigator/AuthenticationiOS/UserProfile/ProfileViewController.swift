//
//  ProfileViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 9/6/22.
//

import UIKit

public typealias CellController = UICollectionViewDataSource

public final class ProfileViewController: UICollectionViewController {
    
    private var controllers = [CellController]()
    
    convenience init() {
        self.init(collectionViewLayout: Self.makeLayout())
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blackBackground
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.identifier)
        collectionView.register(
            UserInfoHeader.self,
            forSupplementaryViewOfKind: UserInfoHeader.viewKind,
            withReuseIdentifier: UserInfoHeader.viewKind
        )
    }
    
    public func setControllers(_ controllers: [CellController]) {
        self.controllers = controllers
        collectionView.reloadData()
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        controllers.count
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        controllers[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        controllers[indexPath.row].collectionView!(
            collectionView,
            viewForSupplementaryElementOfKind: "",
            at: indexPath
        )
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let userInfo = NSCollectionLayoutItem(layoutSize: itemSize)
            userInfo.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 8,
                bottom: 8,
                trailing: 8)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/4))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: userInfo,
                count: 1
            )
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UserInfoHeader.viewKind,
                alignment: .top)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
    }
}

public final class UserInfoViewController: NSObject, UICollectionViewDataSource {
    
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserInfoCell.identifier,
            for: indexPath
        ) as! UserInfoCell
        return cell
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
}

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
    
    private lazy var userAvatarImageView: UIImageView = {
        let imageSize: CGFloat = 125
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                imageView.widthAnchor.constraint(equalToConstant: imageSize),
                imageView.heightAnchor.constraint(equalToConstant: imageSize)
            ]
        )
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize / 2
        return imageView
    }()
    
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
