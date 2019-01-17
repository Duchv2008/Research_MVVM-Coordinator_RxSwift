//
// Created by sergdort on 03/02/2017.
// Copyright (c) 2017 sergdort. All rights reserved.
// Custom by ha.van.duc on 5/28/18.
// Copyright © 2018 Tran Hieu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
    typealias E = ApiError
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<ApiError>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: { error in
            if let apiError = error as? ApiError {
                self.onError(apiError)
            } else {
                self.onError(ApiError())
            }
        })
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, ApiError> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<ApiError> {
        return _subject.asObservable()
    }
    
    private func onError(_ error: ApiError) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
}
