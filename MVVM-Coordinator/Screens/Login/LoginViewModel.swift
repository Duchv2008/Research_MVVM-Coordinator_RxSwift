//
//  LoginViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel, ViewModelType {
    struct Input {
        let username: Observable<String>
        let password: Observable<String>
        let loginTrigger: Observable<Void>
        let registerTrigger: Observable<Void>
        let forgotPasswordTrigger: Observable<Void>

        func dataCombine() -> Observable<(username: String, password: String)> {
            return Observable.combineLatest(username, password) {
                (username: $0, password: $1)
            }
        }
    }

    struct Output {
        let loading: Observable<Bool>
        let error: Observable<ApiError>
        let validate: Observable<Validate>
    }

    struct Validate {
        let isPass: Bool
        let emailError: String
        let passwordError: String
    }

    private var coordinator: LoginCoordinator!

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        let dataCombine = input.dataCombine()

        let validation = dataCombine
            .flatMap { username, password -> Observable<Validate> in
                let validateEmail = Validator.isValidEmail(email: username)
                let validatePassword = Validator.isValidPassword(password: password)
                let result = Validate(isPass: validateEmail.isValid && validatePassword.isValid,
                                      emailError: validateEmail.description,
                                      passwordError: validatePassword.description)
                return Observable.just(result)
            }

       input.loginTrigger
            .withLatestFrom(dataCombine)
            .flatMap { (username, password) -> Driver<LoginResponse> in
                return self.performRequestLogin(username: username, password: password)
            }
            .bind(to: self.coordinator.completedLogin)
            .disposed(by: bag)

        input
            .registerTrigger
            .asObservable()
            .bind(to: self.coordinator.registerTrigger)
            .disposed(by: bag)

        input
            .forgotPasswordTrigger
            .asObservable()
            .bind(to: self.coordinator.forgotPasswordTrigger)
            .disposed(by: bag)

        return Output(loading: trackingIndicator.asObservable(),
                      error: trackingError.asObservable(),
                      validate: validation)
    }

    private func performRequestLogin(username: String, password: String) -> Driver<LoginResponse> {
        return RequestManager
            .shared
            .login(userName: username, password: password)
            .trackError(self.trackingError)
            .trackActivity(trackingIndicator)
            .asDriverOnErrorJustComplete()
    }
}
