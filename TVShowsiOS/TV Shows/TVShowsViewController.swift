//
//  TVShowsViewController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

public final class TVShowsViewController: UICollectionViewController {
    
    public var controllers = [TVShowCellController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    convenience init() {
        self.init(collectionViewLayout: TVShowsViewController.makeLayout())
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackBackground
        collectionView.backgroundColor = .clear
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(TVShowHomeCell.self, forCellWithReuseIdentifier: TVShowHomeCell.dequeueIdentifier)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controllers.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        controllers[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/2))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 2)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
