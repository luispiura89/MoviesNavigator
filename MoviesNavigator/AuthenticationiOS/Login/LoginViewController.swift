//
//  LoginViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import UIKit
import SharediOS
import SharedPresentation

public final class LoginViewController: UIViewController, ErrorView {
    
    public private(set) var loginLoadingViewController: LoginLoadingViewController?
    private var ui = LoginView(frame: .zero)
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

    public func update(_ viewModel: ErrorViewModel) {
        errorViewController?.error = viewModel.message
    }
}
