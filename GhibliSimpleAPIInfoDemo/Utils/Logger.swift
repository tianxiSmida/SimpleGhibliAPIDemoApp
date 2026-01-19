//
//  Logger.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/19.
//

import Foundation

#if DEBUG
let privateFormatter: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "MM-dd HH:mm:ss.SSS"
    return format
}()
#endif

func logInfo(_ items: Any..., separator: String = " ", hasTime: Bool = true) {
#if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print("\(privateFormatter.string(from: Date())) \(output)")
#endif
}
