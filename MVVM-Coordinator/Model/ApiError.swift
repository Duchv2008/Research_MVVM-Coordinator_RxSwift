//
//  ApiErrorRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import ObjectMapper

protocol CustomError: Error {
    var errCode: Int? { get set }
    var message: String? { get set }
    var others: Any? { get set }
}

class ApiError: CustomError, Mappable {
    var errCode: Int?
    var message: String?
    var others: Any?

    private var codeString: String? {
        didSet {
            if let code = Int(codeString ?? "") {
                self.errCode = code
            }
        }
    }

    init(errCode: Int = 0, message: String = "", others: Any? = nil) {
        self.errCode = errCode
        self.message = message
        self.others = others
    }

    required init?(map: Map) {}

    func mapping(map: Map) {
        message <- map["message"]
        codeString <- map["errorCode"]
        others <- map["others"]
    }
}
