//
//  AZCommonCompatible.swift
//  GhibliSimpleAPIInfoDemo
//
//  定義命名空間, 用於區分/快速存取自訂方法
//  Created by TianXi Wu on 2026/1/19.
//

import UIKit

/// ZA沒什麼意義, 只是用於跟一般詞彙做區分, 避免未來有相關的命名衝突
public protocol ZACommonCompatible {
    associatedtype CompatibleType
    static var za: ZACommonWrapper<CompatibleType>.Type { get }
    var za: ZACommonWrapper<CompatibleType> { get }
}

public extension ZACommonCompatible {
    static var za: ZACommonWrapper<Self>.Type {
        ZACommonWrapper<Self>.self
    }
    var za: ZACommonWrapper<Self> {
        ZACommonWrapper(self)
    }
}

public struct ZACommonWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
