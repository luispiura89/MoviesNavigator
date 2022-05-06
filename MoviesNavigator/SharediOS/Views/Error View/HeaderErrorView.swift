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
        backgroundColor = .red.withAlphaComponent(0.6)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismiss() {
        updateErrorMessage(nil)
    }

    private func updateErrorMessage(_ message: String?) {
        setTitle(message, for: .normal)
        if message == nil {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.alpha = 1
            }
        }
    }
}
