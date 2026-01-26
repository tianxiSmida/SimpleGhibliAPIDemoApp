//
//  GBLError.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/12.
//

enum GBLError {
    enum server: Error, Equatable {
        case noInternetConnection
        case tokenInvalid(description: String)
        case undefined(code: Int32, desc: String)
    }
    
    enum model: Error, Equatable {
        case convertModelFailed(description: String)
        case convertPersonIDError(url: String)
    }
}
