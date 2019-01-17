//
//  AppSercurityRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation

/// UnComment when copy Because This code is implementing in Router in folder iOSSwift
struct AppSercurity {
    static var shared = AppSercurity()

    var token: String {
        return self.privateToken ?? ""
    }

    var refreshToken: String {
        let res = userDefault.string(forKey: Key.refreshToken.rawValue) ?? ""
        return res
    }

    private enum Key: String {
        case accessToken
        case refreshToken
    }
    private var userDefault = UserDefaults.standard
    private var privateToken: String?

    private init() {
        self.privateToken = userDefault.string(forKey: Key.accessToken.rawValue)
    }

    mutating func setToken(_ token: String?, refreshToken: String?) {
        self.privateToken = token
        self.userDefault.set(token, forKey: Key.accessToken.rawValue)
        //only update refresh token, when it not null
        if let refreshTk = refreshToken, !refreshTk.isEmpty {
            self.userDefault.set(refreshTk, forKey: Key.refreshToken.rawValue)
        }
        self.userDefault.synchronize()
    }

    mutating func clearToken() {
        self.privateToken = nil
        self.userDefault.removeObject(forKey: Key.accessToken.rawValue)
        self.userDefault.removeObject(forKey: Key.refreshToken.rawValue)
    }

    func  isTokenAvailabble() -> Bool {
        return token.count > 0
    }
}
