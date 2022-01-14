//
//  HeaderErrorView.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import UIKit

public final class HeaderErrorView: UIButton {
    
    public var error: String? {
        set { updateErrorMessage(newValue) }
        get { title(for: .normal) }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red.withAlphaComponent(0.4)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        updateErrorMessage(error)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateErrorMessage(_ message: String?) {
        if message == nil {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.alpha = 0
            } completion: { [weak self] _ in
                self?.error = nil
            }
        } else {
            setTitle(message, for: .normal)
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.alpha = 1
            }
        }
    }
}
