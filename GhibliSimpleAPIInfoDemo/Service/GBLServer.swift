//
//  GBLServer.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/12.
//

import Foundation
import Moya
import Alamofire
import RxSwift

class GBLServer {
    lazy private var provider: MoyaProvider<GBLAPIServer.Request> = setupProvider()
    private let baseInfo: GBLAPIBaseInfoProtocol
    private let monitor: GBLConnectionMonitorProtocol?
    
    init(baseInfo: GBLAPIBaseInfoProtocol, monitor: GBLConnectionMonitorProtocol? = nil) {
        self.baseInfo = baseInfo
        self.monitor = monitor
    }
    
    // MARK: Request
    func fetchFilms() -> Single<[GBLFilm]> {
        request(.films)
    }
}

private extension GBLServer {
    func setupProvider() -> MoyaProvider<GBLAPIServer.Request> {
        let session = createSession()
        var plugins: [PluginType] = []
#if DEBUG
        plugins.append(GBLNetworkLog())
#endif
        plugins.append(CachePolicyPlugin())
        
        return MoyaProvider<GBLAPIServer.Request>(
            endpointClosure: { [weak self] target in
                /// 依據各個 API定義，決定是否需要用 token
                let endPoint = MoyaProvider.defaultEndpointMapping(for: target)
                guard
                    let token = self?.baseInfo.token,
                    target.needToken else {
                    return endPoint
                }
                return endPoint.adding(newHTTPHeaderFields: ["token": token])
            },
            session: session,
            plugins: plugins
        )
    }
    
    func request<T: Codable>(_ req: GBLAPIServer.Request) -> Single<T> {
        
        var request: Single<Response> = provider.rx.request(req)
            .filterSuccessfulStatusCodes()
            .catch { error in
                switch error {
                    // 網路斷線檢測
                case MoyaError.underlying(let subErr, _):
                    if let alamofireError = subErr as? Alamofire.AFError,
                       let underlyingError = alamofireError.underlyingError as NSError?,
                       [NSURLErrorNetworkConnectionLost,
                        NSURLErrorNotConnectedToInternet,
                        NSURLErrorDataNotAllowed,
                        NSURLErrorCannotParseResponse].contains(underlyingError.code) {
                        throw GBLError.server.noInternetConnection
                    } else {
                        throw error
                    }
                    
                default:
                    throw error
                }
            }
        
        // 網路斷線檢測
        if let hasInternetSubject = monitor?.hasInternetSubject,
           hasInternetSubject.value == false {
            request = Observable.error(GBLError.server.noInternetConnection).asSingle()
        }
        
        return request.map { resp in
            do {
                return try JSONDecoder().decode(T.self, from: resp.data)
            } catch {
                throw GBLError.model.convertModelFailed(description: "Convert \(String(describing: T.self)) Fail, \(error)")
            }
        }
    }
    
    func createSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = [.defaultAcceptEncoding, .defaultAcceptLanguage]

        return Session(configuration: configuration, startRequestsImmediately: false)
    }
}
