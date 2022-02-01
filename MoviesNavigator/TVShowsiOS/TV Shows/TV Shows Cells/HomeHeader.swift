//
//  HomeHeader.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 22/12/21.
//

import UIKit

public final class HomeHeader: UICollectionReusableView {
    
    static var reuseIdentifier = "HomeHeader"
    public static var viewKind = "Header"
    
    var loadPopularHandler: (() -> Void)?
    var loadTopRatedHandler: (() -> Void)?
    var loadOnTVHandler: (() -> Void)?
    var loadAiringTodayHandler: (() -> Void)?
    
    public private(set) lazy var selectionSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Popular", "Top Rated", "On TV", "Airing Today"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentTintColor = .homeSegmentBackground
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        segment.addTarget(self, action: #selector(performSelection), for: .valueChanged)
        return segment
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(selectionSegment)
        
        selectionSegment.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        selectionSegment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        bottomAnchor.constraint(equalTo: selectionSegment.bottomAnchor, constant: 8).isActive = true
        trailingAnchor.constraint(equalTo: selectionSegment.trailingAnchor, constant: 8).isActive = true
        backgroundColor = .clear
    }
    
    @objc private func performSelection() {
        switch selectionSegment.selectedSegmentIndex {
        case 0:
            loadPopularHandler?()
        case 1:
            loadTopRatedHandler?()
        case 2:
            loadOnTVHandler?()
        default:
            loadAiringTodayHandler?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
