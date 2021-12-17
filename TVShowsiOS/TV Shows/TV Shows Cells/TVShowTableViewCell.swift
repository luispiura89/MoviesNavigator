//
//  TVShowTableViewCell.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {
    
    static var dequeueIdentifier = "TVShowTableViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tVShowCellTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tVShowCellTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy var voteAverageLabel: UILabel = {
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
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, dateAndVotesStackView, overviewLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dateAndVotesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, voteAverageLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .tVShowCellBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackView)
        bottomStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 8).isActive = true
        view.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: 8).isActive = true
        return view
    }()
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: Self.dequeueIdentifier)
        
        contentView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8).isActive = true
        contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .blackBackground
        selectionStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
