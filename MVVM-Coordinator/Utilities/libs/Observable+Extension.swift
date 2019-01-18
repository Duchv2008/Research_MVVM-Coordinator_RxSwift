//
//  Observable+Extension.swift
//  KidsTVSurprise
//
//  Created by ha.van.duc on 5/28/18.
//  Copyright © 2018 Tran Hieu. All rights reserved.
//

// Lib
// Created by sergdort on 03/02/2017.
// Copyright (c) 2017 sergdort. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension BehaviorSubject {
    func getValue() -> Element? {
        do {
            if let dataValue = try? self.value() {
                return dataValue
            } else {
                return nil
            }
        }
    }
}

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }

}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension ObservableType where E: EventConvertible {
    /**
     Created by Andy Chou on 1/5/17.
     Copyright © 2017 RxSwift Community. All rights reserved.
    */

    /**
     Returns an observable sequence containing only next elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func elements() -> Observable<E.ElementType> {
        return filter { $0.event.element != nil }
            .map { $0.event.element! }
    }

    /**
     Returns an observable sequence containing only error elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func errors() -> Observable<Swift.Error> {
        return filter { $0.event.error != nil }
            .map { $0.event.error! }
    }
}
