//
//  ForgotPasswordViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxSwift

class ForgotPasswordViewModel: BaseViewModel, ViewModelType {
    struct Input {
    }

    struct Output {
        let loading: Observable<Bool>
        let error: Observable<ApiError>
    }

    private var coordinator: ForgotPasswordCoordinator!

    init(coordinator: ForgotPasswordCoordinator) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {
        return Output(loading: trackingIndicator.asObservable(),
                      error: trackingError.asObservable())
    }
}
