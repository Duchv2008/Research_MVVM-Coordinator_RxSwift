//
//  MainViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel: BaseViewModel, ViewModelType {
    struct Input {
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
        return Output(loading: trackingIndicator.asObservable(),
                      error: trackingError.asObservable())
    }
}
