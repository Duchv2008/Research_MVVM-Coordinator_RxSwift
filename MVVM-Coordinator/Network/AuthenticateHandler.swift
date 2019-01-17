//
//  AuthenticateHandlerRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Alamofire

class AuthenticateHandler: RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    private let lock = NSLock()
    private var requestsToRetry: [RequestRetryCompletion] = []
    private var isRefreshing = false

    init() {}

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock();
        defer {
            lock.unlock()
        }

        guard let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == HTTPStatusCode.code401.rawValue else {
                completion(false, 0)
                return
        }
        requestsToRetry.append(completion)

        // If isRefreshing == false => CallRefresh
        if !isRefreshing {
            refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                guard let `self` = self else { return }
                self.lock.lock()
                defer {
                    self.lock.unlock()
                }

                if let accessToken = accessToken, let refreshToken = refreshToken {
                    AppSercurity.shared.setToken(accessToken, refreshToken: refreshToken)
                }
                self.requestsToRetry.forEach({ $0(succeeded, 0) })
                self.requestsToRetry.removeAll()
            }
        }
    }

    /// IF (isRefreshing == true) <return> ELSE <call refresh API>
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        if isRefreshing {
            return
        }
        isRefreshing = true
        _ = RequestManager.shared.refreshToken()
            .subscribe(onNext: { loginResponse in
                completion(true, loginResponse.accessToken, loginResponse.refreshToken)
            }, onError: { error in
                completion(false, nil, nil)
            })
        self.isRefreshing = false
    }
}

