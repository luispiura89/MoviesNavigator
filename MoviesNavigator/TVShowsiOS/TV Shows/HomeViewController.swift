//
//  TVShowsViewController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit
import SharedPresentation
import SharediOS

typealias CellController = UICollectionViewDataSource & UICollectionViewDelegate

public final class HomeViewController: UICollectionViewController {
    
    private var controllers = [CellController]()
    private var headers =  [HomeHeaderController]()
    public private(set) var loadShowsController: HomeRefreshController?
    public private(set) var errorViewController: HeaderErrorViewController?
    
    public convenience init(
        loadController: HomeRefreshController?,
        errorViewController: HeaderErrorViewController?
    ) {
        self.init(collectionViewLayout: HomeViewController.makeLayout())
        self.loadShowsController = loadController
        self.errorViewController = errorViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackBackground
        collectionView.backgroundColor = .clear
        registerCells()
        collectionView.refreshControl = loadShowsController?.refreshView
        errorViewController?.pinErrorViewOnTop(ofView: view)
        loadShowsController?.loadShows()
    }
    
    private func registerCells() {
        collectionView.register(
            TVShowCell.self,
            forCellWithReuseIdentifier: TVShowCell.dequeueIdentifier
        )
        collectionView.register(
            HomeHeader.self,
            forSupplementaryViewOfKind: HomeHeader.viewKind,
            withReuseIdentifier: HomeHeader.reuseIdentifier
        )
    }
    
    public func setHeaders(headers: [HomeHeaderController]) {
        self.headers = headers
    }
    
    public func setCellControllers(controllers: [TVShowCellController]) {
        self.controllers = controllers
        collectionView.reloadData()
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        controllers.count
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        headers.count
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        controllers[indexPath.row].collectionView(
            collectionView,
            cellForItemAt: indexPath
        )
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        headers[indexPath.section].collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: HomeHeader.viewKind,
            at: indexPath
        )
    }
    
    public override func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        controllers[indexPath.row].collectionView?(
            collectionView, didEndDisplaying:
                cell, forItemAt: indexPath
        )
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let showItem = NSCollectionLayoutItem(layoutSize: itemSize)
            showItem.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 8,
                bottom: 8,
                trailing: 8)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: showItem,
                count: 2)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HomeHeader.viewKind,
                alignment: .top)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
    }
}
