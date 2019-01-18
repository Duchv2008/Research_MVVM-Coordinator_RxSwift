//
//  TutorialViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TutorialViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let tutorialTrigger: PublishSubject<Void>
    }

    struct Output {
        let loading: Observable<Bool>
        let error: Observable<ApiError>
    }

    private var coordinator: TutorialCoordinator!

    init(coordinator: TutorialCoordinator) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        input
            .tutorialTrigger
            .asObservable()
            .bind(to: self.coordinator.tutorialCompleted)
            .disposed(by: bag)
        return Output(loading: trackingIndicator.asObservable(),
                      error: trackingError.asObservable())
    }
}
