//
//  Number+AZ.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/19.
//

import UIKit

let refWidth: CGFloat = 375.0
let refHeight: CGFloat = 667.0

extension Int: ZACommonCompatible {}
public extension ZACommonWrapper where Base == Int {
    /// 依據寬度比例縮放
    var scaleWidth: CGFloat {
        let scale = UIScreen.za.screenWidth / refWidth
        return CGFloat(base) * scale
    }
    /// 依據高度比例縮放
    var scaleHeight: CGFloat {
        let scale = UIScreen.za.screenHeight / refHeight
        return CGFloat(base) * scale
    }
}

extension CGFloat: ZACommonCompatible {}
public extension ZACommonWrapper where Base == CGFloat {
    /// 依據寬度比例縮放
    var scaleWidth: CGFloat {
        let scale = UIScreen.za.screenWidth / refWidth
        return base * scale
    }
    /// 依據高度比例縮放
    var scaleHeight: CGFloat {
        let scale = UIScreen.za.screenHeight / refHeight
        return base * scale
    }
}
