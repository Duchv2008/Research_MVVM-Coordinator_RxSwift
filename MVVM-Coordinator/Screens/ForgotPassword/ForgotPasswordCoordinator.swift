//
//  ForgotPasswordCoordinator.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxSwift

class ForgotPasswordCoordinator: BaseCoordinator<Void> {
    private var navigation: UINavigationController!

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    override func start() -> Observable<Void> {
        let forgotVC = UIStoryboard.viewController(identifier: ForgotPasswordViewController.className,
                                                           storyboard: StoryboardName.Main)
        guard let forgotPasswordVC = forgotVC as? ForgotPasswordViewController else {
            return Observable.never()
        }
        navigation.pushViewController(forgotPasswordVC, animated: true)
        return Observable.never()
    }
}
