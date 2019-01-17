//
//  RequestManagerRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import ObjectMapper

private struct Constant {
    static var MappingObjectError: ApiError {
        return ApiError(errCode: HTTPStatusCode.codeMapping.rawValue, message: HTTPStatusCode.codeMapping.message)
    }
}

class RequestManager {
    typealias SuccessHandle = ([String: Any]) -> Void
    typealias FailedHandle = (ApiError) -> Void

    static let shared = RequestManager()
    private let sessionManager: SessionManager!
    private var headers: HTTPHeaders = [:]

    private init() {
        headers["Content-Type"] = "application/json"

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.retrier = AuthenticateHandler()
    }

    /// Base request response Json([String: Any])
    private func baseRequestAPI(url: Router) -> Observable<[String: Any]> {
        return Observable.create({ observer -> Disposable in
            self.sessionManager.request(url).validate()
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: value)
                        guard let json = value as? [String: Any] else {
                            observer.onError(Constant.MappingObjectError)
                            return
                        }
                        observer.onNext(json)
                    case .failure(let error):
                        Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error)
                        if error._code == NSURLErrorTimedOut {
                            let apiErr = ApiError(errCode: HTTPStatusCode.code408.rawValue,
                                                  message: HTTPStatusCode.code408.message)
                            observer.onError(apiErr)
                        } else {
                            guard let httpStatus = response.response?.statusCode,
                                let status = HTTPStatusCode(rawValue: httpStatus) else {
                                observer.onError(Constant.MappingObjectError)
                                return
                            }
                            observer.onError(ApiError(errCode: status.rawValue, message: status.message))
                        }
                    }
                    observer.onCompleted()
                })
            return Disposables.create()
        })
    }

    /// Base request response Mappalbe of ObjectMapper
    private func baseRequestAPI<T: Mappable>(url: Router) -> Observable<T> {
        return Observable.create({ observer -> Disposable in
            self.sessionManager.request(url).validate()
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: value)
                        guard let json = value as? [String: Any], let mapper = Mapper<T>().map(JSON: json) else {
                            observer.onError(Constant.MappingObjectError)
                            return
                        }
                        observer.onNext(mapper)
                    case .failure(let error):
                        Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error)
                        if error._code == NSURLErrorTimedOut {
                            let apiErr = ApiError(errCode: HTTPStatusCode.code408.rawValue,
                                                    message: HTTPStatusCode.code408.message)
                            observer.onError(apiErr)
                        } else {
                            guard let httpStatus = response.response?.statusCode,
                                let status = HTTPStatusCode(rawValue: httpStatus) else {
                                    observer.onError(Constant.MappingObjectError)
                                    return
                            }
                            observer.onError(ApiError(errCode: status.rawValue, message: status.message))
                        }
                    }
                    observer.onCompleted()
                })
            return Disposables.create()
        })
    }
}


// Example
extension RequestManager {
    /// Response model
    func refreshToken() -> Observable<LoginResponse> {
        let refreshUrl = Router.refreshToken
        return self.baseRequestAPI(url: refreshUrl)
    }

    /// Response json [String: Any]
    func login(userName: String, password: String) -> Observable<LoginResponse> {
        let loginUrl = Router.login(email: userName, password: password)
        return self.baseRequestAPI(url: loginUrl)
            .flatMapLatest { json -> Observable<LoginResponse> in
                guard let loginResponse = Mapper<LoginResponse>().map(JSON: json) else {
                    return Observable.error(Constant.MappingObjectError)
                }
                return Observable.just(loginResponse)
        }
    }

    /// Response json [String: Any]
    func register(userName: String, password: String) -> Observable<LoginResponse> {
        let loginUrl = Router.login(email: userName, password: password)
        return self.baseRequestAPI(url: loginUrl)
            .flatMapLatest { json -> Observable<LoginResponse> in
                guard let loginResponse = Mapper<LoginResponse>().map(JSON: json) else {
                    return Observable.error(Constant.MappingObjectError)
                }
                return Observable.just(loginResponse)
        }
    }
}
