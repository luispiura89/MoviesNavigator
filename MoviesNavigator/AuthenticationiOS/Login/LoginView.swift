//
//  LoginView.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import UIKit

public final class LoginView: UIView {
    
    var userTextDidChange: ((String) -> Void)?
    var passwordTextDidChange: ((String) -> Void)?
    
    private lazy var scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    public private(set) lazy var userTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.placeholder = "Username"
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .default
        textfield.heightAnchor.constraint(equalToConstant: 52).isActive = true
        textfield.addTarget(self, action: #selector(updateUser), for: .editingChanged)
        return textfield
    }()
    
    public private(set) lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .default
        textfield.heightAnchor.constraint(equalToConstant: 52).isActive = true
        textfield.addTarget(self, action: #selector(updatePassword), for: .editingChanged)
        return textfield
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blackBackground
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        scrollView.addSubview(mainStackView)
        mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 2/3 - 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLoadingButton(_ loadingButton: UIButton) {
        mainStackView.addArrangedSubview(loadingButton)
    }
    
    @objc private func updateUser() {
        userTextDidChange?(userTextField.text ?? "")
    }
    
    @objc private func updatePassword() {
        passwordTextDidChange?(passwordTextField.text ?? "")
    }
}
