//
//  Definition.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/19.
//

import UIKit

extension UIScreen: ZACommonCompatible {}

public extension ZACommonWrapper where Base == UIScreen {
    /// screen Width
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    /// screen Height
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

/// 不考慮橫豎方向，取最原本的 width
public let minScreenWidth = min(UIScreen.za.screenWidth, UIScreen.za.screenHeight)
/// 不考慮橫豎方向，取最原本的 height
public let maxScreenHeight = max(UIScreen.za.screenWidth, UIScreen.za.screenHeight)
