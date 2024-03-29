//
//  MainCoordinator.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift

class MainCoordinator: BaseCoordinator<Void> {
    private var window: UIWindow!
    private var isHasAnimation: Bool

    var logoutTrigger = PublishSubject<Void>()

    init(window: UIWindow, isHasAnimation: Bool = true) {
        self.window = window
        self.isHasAnimation = isHasAnimation
    }

    override func start() -> Observable<Void> {
        let mainVC = UIStoryboard.viewController(identifier: MainViewController.className,
                                                     storyboard: StoryboardName.Main)
        guard let mainViewController = mainVC as? MainViewController else {
            return Observable.never()
        }

        let viewModel = MainViewModel(coordinator: self)
        mainViewController.viewModel = viewModel
        let registerNavigation = UINavigationController(rootViewController: mainViewController)
        window.set(rootViewController: registerNavigation,
                   withTransition: isHasAnimation ? AppDelegate.shared?.changeViewAnimation : nil)
        self.window.makeKeyAndVisible()

        logoutTrigger
            .asObservable()
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.redirectoLogin()
            }.disposed(by: bag)

        return Observable.never()
    }

    private func redirectoLogin() {
        let loginCoordinator = LoginCoordinator(window: self.window)
        coordinate(to: loginCoordinator).subscribe().disposed(by: bag)
    }
}
