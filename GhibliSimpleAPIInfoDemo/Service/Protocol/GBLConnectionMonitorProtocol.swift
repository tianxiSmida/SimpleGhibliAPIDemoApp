//
//  GBLConnectionMonitorProtocol.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/12.
//

import Foundation
import RxRelay

protocol GBLConnectionMonitorProtocol {
    var hasInternetSubject: BehaviorRelay<Bool> { get }
}
