//
//  LoginViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import UIKit
import SharediOS
import SharedPresentation

protocol LoginViewControllerDelegate {
    func update(user: String)
    func update(password: String)
}

public final class LoginViewController: UIViewController {
    
    public private(set) var loginLoadingViewController: LoginLoadingViewController?
    private let ui = LoginView(frame: .zero)
    public private(set) var errorViewController: HeaderErrorViewController?
    
    public convenience init(
        loginLoadingViewController: LoginLoadingViewController,
        errorViewController: HeaderErrorViewController
    ) {
        self.init()
        self.loginLoadingViewController = loginLoadingViewController
        self.errorViewController = errorViewController
    }
    
    public override func loadView() {
        view = ui
        ui.addLoadingButton(loginLoadingViewController?.view ?? UIButton())
        errorViewController?.pinErrorViewOnTop(ofView: ui)
    }
}
