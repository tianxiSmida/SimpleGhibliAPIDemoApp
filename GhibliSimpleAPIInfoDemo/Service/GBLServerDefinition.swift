//
//  GBLServerDefinition.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/12.
//

import Foundation
import Moya

enum GBLAPIServer {
    enum Request {
        case films
        case peoples
    }
}

extension GBLAPIServer.Request: TargetType {
    var baseURL: URL {
        return URL(string: "https://ghibliapi.vercel.app")!
    }
    
    var path: String {
        switch self {
        case .films:
            return "/films"
        case .peoples:
            return "/peoples"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        let header = [
            "Accept": "application/x-protobuf;charset=UTF-8, text/plain, application/xml, application/json, application/*+json, */*",
            "Content-Type": "application/x-protobuf;charset=UTF-8"
        ]
        return header
    }
}

extension GBLAPIServer.Request {
    /* 依據 API性質區分是否需要 token */
    var needToken: Bool {
        switch self {
        default:
            return false
        }
    }
}

extension GBLAPIServer.Request: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        default:
            return .useProtocolCachePolicy
        }
    }
}
