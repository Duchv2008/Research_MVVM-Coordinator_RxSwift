//
//  ViewModelType.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
