//
//  RegisterCoordinator.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxSwift

class RegisterCoordinator: BaseCoordinator<Void> {
    private var window: UIWindow!
    private var isHasAnimation: Bool

    var registerCompleted = PublishSubject<LoginResponse>()
    var haveAccountTrigger = PublishSubject<Void>()

    init(window: UIWindow, isHasAnimation: Bool = true) {
        self.window = window
        self.isHasAnimation = isHasAnimation
    }

    override func start() -> Observable<Void> {
        let registerVC = UIStoryboard.viewController(identifier: RegisterViewController.className,
                                                                 storyboard: StoryboardName.Main)
        guard let registerViewController = registerVC as? RegisterViewController else {
            return Observable.never()
        }

        let viewModel = RegisterViewModel(coordinator: self)
        registerViewController.viewModel = viewModel
        let registerNavigation = UINavigationController(rootViewController: registerViewController)
        self.window.set(rootViewController: registerNavigation,
                        withTransition: isHasAnimation ? AppDelegate.shared?.changeViewAnimation : nil)
        window.makeKeyAndVisible()

        registerCompleted
            .bind { [weak self] loginResponse in
                guard let `self` = self else { return }
                self.redirectToMainScreen()
            }.disposed(by: bag)

        haveAccountTrigger
            .asObservable()
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.redirectToLoginScreen()
            }.disposed(by: bag)

        return Observable.never()
    }

    private func redirectToMainScreen() {
        let mainCoordinator = MainCoordinator(window: self.window)
        coordinate(to: mainCoordinator).subscribe().disposed(by: bag)
    }

    private func redirectToLoginScreen() {
        let loginCoordinator = LoginCoordinator(window: self.window)
        coordinate(to: loginCoordinator).subscribe().disposed(by: bag)
    }
}
