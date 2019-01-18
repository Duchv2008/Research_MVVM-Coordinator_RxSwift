//
//  RouterRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import Alamofire

private struct Constant {
    static let headerAccessTokenKey = "AccessToken"
}

enum Router: URLRequestConvertible {
    static let baseUrlString = "http://5c2eb79a2fffe80014bd696b.mockapi.io/api/v1/"

    case login(email: String, password: String)
    case refreshToken
    case logout

    var method: HTTPMethod {
        switch self {
        case .login, .refreshToken, .logout:
            return .post
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return "login"
        case .refreshToken:
            return "refreshToken"
        case .logout:
            return "logout"
        default:
            break
        }
    }

    var paramater: Parameters? {
        var params: Parameters? = nil
        switch self {
        case .login(let email, let password):
            params = loginParamater(email: email, password: password)
        case .refreshToken:
            params = refreshTokenParamater()
        default:
            break
        }
        return params
    }

    private var autoAddToken: Bool {
        switch self {
        case .login:
            return false
        default:
            return true
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseUrlString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setAccessToken(autoAddToken)
        urlRequest = try URLEncoding.default.encode(urlRequest, with: paramater)
        return urlRequest
    }
}

/// UnComment when copy Because This code is implementing in Router in folder iOSSwift
extension URLRequest {
    mutating func setAccessToken(_ add: Bool) {
        guard add else { return }
        guard AppSercurity.shared.isTokenAvailabble() else { return }
        self.setValue(AppSercurity.shared.token, forHTTPHeaderField: Constant.headerAccessTokenKey)
    }
}

extension Router {
    private func loginParamater(email: String, password: String) -> Parameters {
        return [
            "email": email,
            "password": password
        ]
    }

    private func refreshTokenParamater() -> Parameters {
        return [
            "refreshToken": AppSercurity.shared.refreshToken
        ]
    }
}
