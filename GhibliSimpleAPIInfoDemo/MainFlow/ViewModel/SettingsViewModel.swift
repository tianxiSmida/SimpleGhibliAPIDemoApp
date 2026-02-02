//
//  SettingsViewModel.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/26.
//

import RxSwift
import RxCocoa

enum SettingAppearance: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
}

class SettingsViewModel {
    struct Input {
        let appearanceSelected: Observable<SettingAppearance>
        let usernameChanged: Observable<String?>
        let itemsPerPageChanged: Observable<Double>
        let notificationsToggled: Observable<Bool>
        let resetTapped: Observable<Void>
    }
    
    struct Output {
        let selectedAppearance: Driver<SettingAppearance>
        let username: Driver<String?>
        let itemsPerPageText: Driver<String>
        let isNotificationEnabled: Driver<Bool>
        let reloadTableView: Signal<Void>
    }
    
    private let provider: SettingsManagerProtocol
    private let disposeBag = DisposeBag()
    
    // States
    private let appearanceRelay = BehaviorRelay<SettingAppearance>(value: .system)
    private let usernameRelay = BehaviorRelay<String?>(value: "")
    private let itemsPerPageRelay = BehaviorRelay<Int>(value: 20)
    private let notificationsRelay = BehaviorRelay<Bool>(value: true)
    private let reloadRelay = PublishRelay<Void>()

    init(provider: SettingsManagerProtocol) {
        self.provider = provider
        setupInitialValues()
    }
    
    private func setupInitialValues() {
        let initialValue = provider.getSaveSettings()
        appearanceRelay.accept(initialValue.appearence)
        usernameRelay.accept(initialValue.userName)
        itemsPerPageRelay.accept(initialValue.pageSize)
        notificationsRelay.accept(initialValue.enableNoification)
    }
    
    func transform(input: Input) -> Output {
        let provider = self.provider
        input.appearanceSelected
            .bind(to: appearanceRelay)
            .disposed(by: disposeBag)
        
        input.usernameChanged
            .skip(1) // 雙向綁定, 忽略第一次輸入資料, 避免VM初始值被空值覆蓋
            .do(onNext: provider.saveUsername(_:))
            .bind(to: usernameRelay)
            .disposed(by: disposeBag)
        
        input.itemsPerPageChanged
            .map { Int($0) }
            .do(onNext: provider.savePageSize(_:))
            .bind(to: itemsPerPageRelay)
            .disposed(by: disposeBag)
        
        input.notificationsToggled
            .do(onNext: provider.saveEnableNotification(_:))
            .bind(to: notificationsRelay)
            .disposed(by: disposeBag)
        
        input.resetTapped
            .subscribe(onNext: { [weak self] in
                self?.appearanceRelay.accept(SettingsDefaultValue.appearance)
                self?.usernameRelay.accept(SettingsDefaultValue.userName)
                self?.itemsPerPageRelay.accept(SettingsDefaultValue.itemsPerPage)
                self?.notificationsRelay.accept(SettingsDefaultValue.notificationsEnabled)
                self?.reloadRelay.accept(())
            })
            .disposed(by: disposeBag)

        // 當外觀改變時也通知 TableView 重新整理以更新 Checkmark
        appearanceRelay
            .mapToVoid()
            .bind(to: reloadRelay)
            .disposed(by: disposeBag)
        
        appearanceRelay
            .distinctUntilChanged()
            .skip(1)
            .bind(onNext: provider.saveAppearence(_:))
            .disposed(by: disposeBag)

        return Output(
            selectedAppearance: appearanceRelay.asDriver(),
            username: usernameRelay.asDriver(),
            itemsPerPageText: itemsPerPageRelay.map { "Items per page: \($0)" }.asDriver(onErrorJustReturn: ""),
            isNotificationEnabled: notificationsRelay.asDriver(),
            reloadTableView: reloadRelay.asSignal()
        )
    }
}
