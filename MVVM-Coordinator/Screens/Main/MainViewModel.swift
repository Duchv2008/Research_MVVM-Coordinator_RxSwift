//
//  MainViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let logoutTrigger: Observable<Void>
    }

    struct Output {
        let loading: Observable<Bool>
        let error: Observable<ApiError>
    }

    private var coordinator: MainCoordinator!

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        input.logoutTrigger
            .flatMapLatest({ _ -> Driver<Void> in
                return self.logout()
            })
            .bind(to: coordinator.logoutTrigger)
            .disposed(by: bag)

        return Output(loading: trackingIndicator.asObservable(),
                      error: trackingError.asObservable())
    }

    private func logout() -> Driver<Void> {
        return RequestManager
            .shared
            .logout()
            .trackError(self.trackingError)
            .trackActivity(self.trackingIndicator)
            .asDriverOnErrorJustComplete()
    }
}
