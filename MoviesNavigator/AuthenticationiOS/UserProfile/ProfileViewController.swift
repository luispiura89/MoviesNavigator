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
    private var headers = [CellController]()
    public private(set) var loadingController: ProfileLoadingController?
    public private(set) var errorViewController: HeaderErrorViewController?
    
    public convenience init(
        loadingController: ProfileLoadingController? = nil,
        errorViewController: HeaderErrorViewController? = nil
    ) {
        self.init(collectionViewLayout: Self.makeLayout())
        self.loadingController = loadingController
        self.errorViewController = errorViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = loadingController?.view
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
        collectionView.register(
            UserFavoriteShowsHeader.self,
            forSupplementaryViewOfKind: UserFavoriteShowsHeader.viewKind,
            withReuseIdentifier: UserFavoriteShowsHeader.viewKind
        )
        collectionView.register(
            EmptyFavoriteShowsCell.self,
            forCellWithReuseIdentifier: EmptyFavoriteShowsCell.identifier
        )
        errorViewController?.pinErrorViewOnTop(ofView: view)
    }
    
    public func setControllers(_ controllers: [CellController], forSection section: Int = 0) {
        self.controllers[section] = controllers
        collectionView.reloadData()
    }
    
    public func updateForEmptyFavoriteShows() {
        collectionView.collectionViewLayout = Self.makeLayout(hasFavoriteShows: false)
    }
    
    public func setHeaders(_ headers: [CellController]) {
        self.headers = headers
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
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard indexPath.section < headers.count else { return UICollectionReusableView() }
        return headers[indexPath.section].collectionView?(
            collectionView,
            viewForSupplementaryElementOfKind: "",
            at: indexPath
        ) ?? UICollectionReusableView()
    }
    
    private func cellControllers(forSection section: Int = 0) -> [CellController] {
        controllers[section] ?? []
    }
    
    private static func makeLayout(hasFavoriteShows: Bool = true) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { section, _ in
            section == 0 ?
            makeUserProfileSectionLayout() :
            hasFavoriteShows ? makeLikedShowsSectionLayout() : makeUserProfileSectionLayout()
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
