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
    
    public private(set) var loginLoadingViewController = LoginLoadingViewController()
    private var ui = LoginView(frame: .zero)
    private var errorViewController = HeaderErrorViewController()
    
    public override func loadView() {
        view = ui
        ui.addLoadingButton(loginLoadingViewController.view)
        errorViewController.pinErrorViewOnTop(ofView: ui)
    }

    public func update(_ viewModel: ErrorViewModel) {
        errorViewController.error = viewModel.message
    }
}
