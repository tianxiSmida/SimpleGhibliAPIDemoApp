//
//  GBLNetworkLog.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/19.
//

import Moya

internal final class GBLNetworkLog: PluginType {
    let formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MM-dd HH:mm:ss.SSS"
        return format
    }()
    
    func willSend(_ request: RequestType, target: TargetType) {
        logInfo("[送✉️][\(target.path)], request: \(target)")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if case Result.failure(let error) = result {
            logInfo("[收🎁][\(target.path)] request: \(target), error: \(error)")
        }
    }
}
