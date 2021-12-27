//
//  HomeHeader.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 22/12/21.
//

import UIKit

final class HomeHeader: UICollectionReusableView {
    
    static var reuseIdentifier = "HomeHeader"
    static var viewKind = "Header"
    
    lazy var selectionSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Popular", "Top Rated", "On TV", "Airing Today"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentTintColor = .homeSegmentBackground
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
