//
//  SettingsManager.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/26.
//

import RxSwift

enum SettingsDefaultValue {
    static let appearance: SettingAppearance = .system
    static let itemsPerPage: Int = 20
    static let userName: String = ""
    static let notificationsEnabled: Bool = true
}

struct SettingsInfoModel {
    let appearence: SettingAppearance
    let userName: String?
    let pageSize: Int
    let enableNoification: Bool
}

protocol SettingsManagerProtocol {
    var theme: Observable<UIUserInterfaceStyle> { get }
    
    func getSaveSettings() -> SettingsInfoModel
    func saveAppearence(_ appearence: SettingAppearance)
    func saveUsername(_ username: String?)
    func savePageSize(_ pageSize: Int)
    func saveEnableNotification(_ isEnable: Bool)
}

class SettingsManager {
    
    let storage: GBLSettingsDataStorageProtocol
    
    private lazy var themeSubject: BehaviorSubject<SettingAppearance> = .init(value: SettingAppearance(rawValue: storage.loadAppearence()) ?? SettingsDefaultValue.appearance)
    
    init(storage: GBLSettingsDataStorageProtocol) {
        self.storage = storage
    }
}

extension SettingsManager: SettingsManagerProtocol {
    var theme: RxSwift.Observable<UIUserInterfaceStyle> {
        themeSubject.asObservable().compactMap {
            if #unavailable(iOS 13.0) {
                return nil
            }
            switch $0 {
            case .system:
                return UIUserInterfaceStyle.unspecified
            case .light:
                return UIUserInterfaceStyle.light
            case .dark:
                return UIUserInterfaceStyle.dark
            }
        }
    }
    
    func getSaveSettings() -> SettingsInfoModel {
        let appearence = SettingAppearance(rawValue: storage.loadAppearence()) ?? SettingsDefaultValue.appearance
        return .init(appearence: appearence,
                     userName: storage.loadUsername(),
                     pageSize: storage.loadPageSize(),
                     enableNoification: storage.loadEnableNotification())
    }
    
    func saveAppearence(_ appearence: SettingAppearance) {
        storage.saveAppearence(appearence.rawValue)
        themeSubject.onNext(appearence)
    }
    
    func saveUsername(_ username: String?) {
        storage.saveUsername(username)
    }
    
    func savePageSize(_ pageSize: Int) {
        storage.savePageSize(pageSize)
    }
    
    func saveEnableNotification(_ isEnable: Bool) {
        storage.saveEnableNotification(isEnable)
    }
}
