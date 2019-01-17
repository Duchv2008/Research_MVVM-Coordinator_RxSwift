//
//  LoginResponseRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: Mappable {
    var accessToken: String?
    var refreshToken: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
}
