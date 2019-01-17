//
//  Logger.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation

struct Logger {
    static func log(msg: String) {
        print("Debug: \(msg)")
    }

    static func logRequest(urlRequest: URLRequest?, param: [String: Any]?, msg: Any?) {
        guard let request = urlRequest else { return }
        print("\n \(String(describing: request.httpMethod ?? "Nil Method")): \(String(describing: request.url?.absoluteString ?? "")) \n")
        print("Param: \(String(describing: param ?? [:])) \n")
        print("Response: \(String(describing: msg ?? "")) \n")
    }
}
