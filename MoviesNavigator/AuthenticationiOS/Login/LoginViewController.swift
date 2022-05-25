//
//  LoginViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import UIKit
import SharediOS
import SharedPresentation

public protocol LoginViewControllerDelegate {
    func update(user: String)
    func update(password: String)
}

public final class LoginViewController: UIViewController {
    
    public private(set) var loginLoadingViewController: LoginLoadingViewController?
    public private(set) var ui = LoginView(frame: .zero)
    public private(set) var errorViewController: HeaderErrorViewController?
    private var delegate: LoginViewControllerDelegate?
    
    public convenience init(
        loginLoadingViewController: LoginLoadingViewController,
        errorViewController: HeaderErrorViewController,
        delegate: LoginViewControllerDelegate? = nil
    ) {
        self.init()
        self.loginLoadingViewController = loginLoadingViewController
        self.errorViewController = errorViewController
        self.delegate = delegate
    }
    
    public override func loadView() {
        view = ui
        ui.addLoadingButton(loginLoadingViewController?.view ?? UIButton())
        errorViewController?.pinErrorViewOnTop(ofView: ui)
        ui.userTextDidChange = { [weak self] user in
            self?.delegate?.update(user: user)
        }
        ui.passwordTextDidChange = { [weak self] password in
            self?.delegate?.update(password: password)
        }
    }
}
