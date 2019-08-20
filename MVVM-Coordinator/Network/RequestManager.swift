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
    func baseRequestAPI(url: Router) -> Observable<[String: Any]> {
        return Observable.create({ observer -> Disposable in
            self.sessionManager.request(url)
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
                        let error = self.handleErrorResponse(error: error, response: response, url: url)
                        observer.onError(error)
                    }
                    observer.onCompleted()
                })
            return Disposables.create()
        })
    }

    /// Base request response Mappalbe of ObjectMapper
    func baseRequestAPI<T: Mappable>(url: Router) -> Observable<T> {
        return Observable.create({ observer -> Disposable in
            self.sessionManager.request(url)
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
                        let error = self.handleErrorResponse(error: error, response: response, url: url)
                        observer.onError(error)
                    }
                    observer.onCompleted()
                })
            return Disposables.create()
        })
    }

    func baseUploadMedia(url: Router, media: Data, fileName: String? = nil, mimeType: String = "video/mp4") -> Observable<[[String: Any]]> {
        let newFileName = fileName ?? String(format: "%d", Int(Date().timeIntervalSince1970))
        return Observable.create({ observer -> Disposable in
            self.sessionManager.upload(multipartFormData: { (multipart) in
                multipart.append(media, withName: "File", fileName: newFileName, mimeType: mimeType)
            }, with: url, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: value)
                            guard let json = value as? [[String: Any]] else {
                                observer.onError(Constant.MappingObjectError)
                                return
                            }
                            observer.onNext(json)
                        case .failure(let error):
                            let error = self.handleErrorResponse(error: error, response: response, url: url)
                            observer.onError(error)
                        }
                        observer.onCompleted()
                    }
                case .failure(let encodingError):
                    observer.onError(ApiError(errCode: HTTPStatusCode.codeMapping.rawValue, message: encodingError.localizedDescription))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }

    private func handleErrorResponse(error: Error, response: DataResponse<Any>, url: Router) -> ApiError {
        if error._code == NSURLErrorTimedOut {
            Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
            return ApiError(errCode: HTTPStatusCode.code408.rawValue, message: HTTPStatusCode.code408.message)
        } else {
            guard let data = response.data else {
                guard let httpStatus = response.response?.statusCode, let status = HTTPStatusCode(rawValue: httpStatus) else {
                    return Constant.MappingObjectError
                }
                Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
                return ApiError(errCode: status.rawValue, message: status.message)
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                    Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: jsonArray)
                    if let code = jsonArray["code"] as? Int, let message = jsonArray["message"] as? String {
                        return ApiError(errCode: code, message: message)
                    } else {
                        return Constant.MappingObjectError
                    }
                } else {
                    Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
                    return Constant.MappingObjectError
                }
            } catch let error as NSError {

                Logger.logRequest(urlRequest: url.urlRequest, param: url.paramater, msg: error.localizedDescription)
                return ApiError(errCode: response.response?.statusCode ?? 0, message: error.localizedDescription)
            }
        }
    }
}


// Example
extension RequestManager {
    /// Response model
    func refreshToken() -> Observable<LoginResponse> {
        let refreshUrl = Router.refreshToken
        return self.baseRequestAPI(url: refreshUrl)
    }

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

    func logout() -> Observable<Void> {
        let logoutUrl = Router.logout
        return self.baseRequestAPI(url: logoutUrl)
            .flatMapLatest({ _ -> Observable<Void> in
                return Observable.just(())
            })
    }
}
