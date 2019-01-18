//
//  RegisterViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
        let registerTrigger: Observable<Void>
        let haveAccountTrigger: Observable<Void>

        func dataCombine() -> Observable<(username: String, password: String)> {
            return Observable.combineLatest(username, password) {
                (username: $0, password: $1)
            }
        }
    }

    struct Output {
        let loading: Observable<Bool>
        let error: Observable<ApiError>
    }

    private var coordinator: RegisterCoordinator!

    init(coordinator: RegisterCoordinator) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        input.registerTrigger
            .withLatestFrom(input.dataCombine())
            .flatMapLatest { (username, password) -> Driver<LoginResponse> in
                return self.performRequestRegister(username: username, password: password)
            }
            .bind(to: self.coordinator.registerCompleted)
            .disposed(by: bag)

        input.haveAccountTrigger
            .bind(to: self.coordinator.haveAccountTrigger)
            .disposed(by: bag)

        return Output(loading: trackingIndicator.asObservable(),
                      error: trackingError.asObservable())
    }

    private func performRequestRegister(username: String, password: String) -> Driver<LoginResponse> {
        return RequestManager
            .shared
            .register(userName: username, password: password)
            .trackError(self.trackingError)
            .trackActivity(self.trackingIndicator)
            .asDriverOnErrorJustComplete()
    }
}
