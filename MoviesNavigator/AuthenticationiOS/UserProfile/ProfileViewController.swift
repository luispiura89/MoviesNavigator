//
//  ProfileViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 9/6/22.
//

import UIKit
import SharediOS

public typealias CellController = UICollectionViewDataSource

public final class ProfileViewController: UICollectionViewController {
    
    private var controllers = [Int: [CellController]]()
    
    convenience init() {
        self.init(collectionViewLayout: Self.makeLayout())
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blackBackground
        collectionView.register(
            UserInfoCell.self,
            forCellWithReuseIdentifier: UserInfoCell.identifier
        )
        collectionView.register(
            TVShowCell.self,
            forCellWithReuseIdentifier: TVShowCell.dequeueIdentifier
        )
        collectionView.register(
            UserInfoHeader.self,
            forSupplementaryViewOfKind: UserInfoHeader.viewKind,
            withReuseIdentifier: UserInfoHeader.viewKind
        )
    }
    
    public func setControllers(_ controllers: [CellController], forSection section: Int = 0) {
        self.controllers[section] = controllers
        collectionView.reloadData()
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        controllers[section]?.count ?? 0
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        controllers.keys.count
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let controllers = cellControllers(forSection: indexPath.section)
        return controllers[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    private func cellControllers(forSection section: Int = 0) -> [CellController] {
        controllers[section] ?? []
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { section, _ in
            section == 0 ? makeUserProfileSectionLayout() : makeLikedShowsSectionLayout()
        }
    }
    
    private static func makeUserProfileSectionLayout() -> NSCollectionLayoutSection {
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
    
    private static func makeLikedShowsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let showItem = NSCollectionLayoutItem(layoutSize: itemSize)
        showItem.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(8/7),
            heightDimension: .fractionalHeight(1/2))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: showItem,
            count: 2
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
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}
