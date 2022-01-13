//
//  TVShowHomeCell.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

public final class TVShowHomeCell: UICollectionViewCell {
    
    static var dequeueIdentifier = "TVShowTableViewCell"
    
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tVShowCellTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return label
    }()
    
    public lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return label
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tVShowCellTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    public lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tVShowCellTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, bottomStackView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(retryLoadingButton)
        retryLoadingButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0).isActive = true
        retryLoadingButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: retryLoadingButton.bottomAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: retryLoadingButton.trailingAnchor, constant: 0).isActive = true
        return imageView
    }()
    
    lazy var retryLoadingButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage.retryLoading, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, dateAndVotesStackView, overviewLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var dateAndVotesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, voteAverageLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .tVShowCellBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
