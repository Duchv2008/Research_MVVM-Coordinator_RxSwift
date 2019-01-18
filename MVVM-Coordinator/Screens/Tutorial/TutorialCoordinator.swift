//
//  TutorialCoordinator.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift

class TutorialCoordinator: BaseCoordinator<Void> {
    private var navigation: UINavigationController!
    var tutorialCompleted = PublishSubject<Void>()

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    override func start() -> Observable<Void> {
        let tutorialVC = UIStoryboard.viewController(identifier: TutorialViewController.className,
                                                   storyboard: StoryboardName.Tutorial)
        guard let tutorialViewController = tutorialVC as? TutorialViewController else {
            return Observable.never()
        }
        tutorialViewController.viewModel = TutorialViewModel(coordinator: self)
        navigation.pushViewController(tutorialViewController, animated: true)

        tutorialCompleted
            .asObservable()
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.redirectToMainScreen()
            }.disposed(by: bag)
        return Observable.never()
    }

    private func redirectToMainScreen() {
        let mainCoordinator = MainCoordinator(window: (AppDelegate.shared?.window)!)
        coordinate(to: mainCoordinator).subscribe().disposed(by: bag)
    }
}

