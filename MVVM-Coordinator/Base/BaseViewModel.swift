//
//  BaseViewModel.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    var trackingIndicator: ActivityIndicator!
    var trackingError: ErrorTracker!
    var bag = DisposeBag()

    init() {
        trackingIndicator = ActivityIndicator()
        trackingError = ErrorTracker()
    }
}
