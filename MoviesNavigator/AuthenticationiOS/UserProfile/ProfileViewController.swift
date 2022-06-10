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
        controllers[indexPath.row].collectionView?(
            collectionView,
            viewForSupplementaryElementOfKind: "",
            at: indexPath
        ) ?? UICollectionReusableView()
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
