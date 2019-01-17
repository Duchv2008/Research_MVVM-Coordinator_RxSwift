//
//  NetworkRequestConstant.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation

///Define http status

public enum HTTPStatusCode: Int {
    // OK
    case code200       = 200

    // Mapping Object
    case codeMapping   = 99

    // Invalid parameter supplied
    case code400       = 400

    // Invalid Token
    case code401       = 401

    // Timeout
    case code408       = 408

    // Too many requests
    case code429       = 429

    // Network error
    case code404       = 404

    // TODO: Implement on each project
    var message: String {
        switch self {
        case .code400:
            return ""
        default:
            return ""
        }
    }
}
