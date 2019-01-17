//
//  LoginCoordinator.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxSwift

class LoginCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow

    lazy var completedLogin = PublishSubject<LoginResponse>()
    lazy var registerTrigger = PublishSubject<Void>()
    lazy var forgotPasswordTrigger = PublishSubject<Void>()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        guard let loginViewController = UIStoryboard
            .viewController(identifier: LoginViewController.className, storyboard: StoryboardName.Main) as? LoginViewController else {
                return Observable.never()
        }
        let loginViewModel = LoginViewModel(coordinator: self)
        loginViewController.viewModel = loginViewModel

        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()

        completedLogin
            .asObservable()
            .bind { [weak self] loginResponse in
                guard let `self` = self else { return }
                self.redirectToMainScreen()
            }.disposed(by: bag)

        registerTrigger
            .asObservable()
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.redirectToRegisterScreen()
            }.disposed(by: bag)

        forgotPasswordTrigger
            .asObservable()
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.redirectToForgotPasswordScreen(in: navigationController)
            }.disposed(by: bag)

        return Observable.never()
    }

    private func redirectToRegisterScreen() {
        let registerCoordinator = RegisterCoordinator(window: self.window)
        coordinate(to: registerCoordinator).subscribe().disposed(by: bag)
    }

    private func redirectToMainScreen() {
        let mainCoordinator = MainCoordinator(window: self.window)
        coordinate(to: mainCoordinator).subscribe().disposed(by: bag)
    }

    private func redirectToForgotPasswordScreen(in navigation: UINavigationController) {
        let forgotPasswordCoordinator = ForgotPasswordCoordinator(navigation: navigation)
        coordinate(to: forgotPasswordCoordinator).subscribe().disposed(by: bag)
    }
}
