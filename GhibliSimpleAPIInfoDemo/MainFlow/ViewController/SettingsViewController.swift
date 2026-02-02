//
//  SettingsViewController.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/26.
//

import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    private let viewModel: SettingsViewModel
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let usernameTextField = UITextField()
    private let preferenceItemsPerPageLabel = UILabel()
    private let stepper = UIStepper()
    private let notificationSwitch = UISwitch()
    
    private var selectedAppearance: SettingAppearance = .system
    private let disposeBag = DisposeBag()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 44.za.scaleWidth
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        usernameTextField.placeholder = "Username"
        notificationSwitch.onTintColor = .systemGreen
    }
    
    private func bindViewModel() {
        let tapAppearance = tableView.rx.itemSelected
            .filter { $0.section == Section.appearance.rawValue }
            .compactMap { SettingAppearance(rawValue: $0.row) }
        let tapReset = tableView.rx.itemSelected
            .filter { $0.section == Section.reset.rawValue }
            .mapToVoid()
        let input = SettingsViewModel.Input(
            appearanceSelected: tapAppearance,
            usernameChanged: usernameTextField.rx.text.asObservable(),
            itemsPerPageChanged: stepper.rx.value.asObservable(),
            notificationsToggled: notificationSwitch.rx.isOn.asObservable(),
            resetTapped: tapReset
        )
        
        let output = viewModel.transform(input: input)
        
        // UI Binding
        output.selectedAppearance
            .drive(with: self, onNext: {
                $0.selectedAppearance = $1
            }).disposed(by: disposeBag)
        output.username.drive(usernameTextField.rx.text).disposed(by: disposeBag)
        output.isNotificationEnabled.drive(notificationSwitch.rx.isOn).disposed(by: disposeBag)
        
        output.reloadTableView
            .emit(onNext: { [weak self] in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.itemsPerPageText
            .drive(preferenceItemsPerPageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView Logic
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)?.numsOfRow ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let section = Section(rawValue: indexPath.section)
        
        switch section {
        case .appearance:
            let options = SettingAppearance(rawValue: indexPath.row)
            cell.textLabel?.text = options?.title
            cell.accessoryType = indexPath.row == self.selectedAppearance.rawValue ? .checkmark : .none
            
        case .account:
            cell.contentView.addSubview(usernameTextField)
            usernameTextField.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.right.equalToSuperview().inset(20.za.scaleWidth)
                make.height.lessThanOrEqualToSuperview()
            }
        case .preferences:
            if indexPath.row == 0 {
                cell.contentView.addSubview(preferenceItemsPerPageLabel)
                cell.accessoryView = stepper
                
                preferenceItemsPerPageLabel.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().inset(20.za.scaleWidth)
                    make.height.lessThanOrEqualToSuperview()
                }
            } else {
                cell.textLabel?.text = "Enable notifications"
                cell.accessoryView = notificationSwitch
            }
            
        case .reset: // Reset
            cell.textLabel?.text = "Reset to Defaults"
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .default
            
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == Section.appearance.rawValue ? "Overrides the system appearance to always use Light." : nil
    }
}

extension SettingsViewController {
    enum Section: Int, CaseIterable {
        case appearance = 0
        case account
        case preferences
        case reset
        
        var numsOfRow: Int {
            switch self {
            case .appearance:
                3
            case .account:
                1
            case .preferences:
                2
            case .reset:
                1
            }
        }
        var title: String? {
            switch self {
            case .appearance:
                "Appearance"
            case .account:
                "Account"
            case .preferences:
                "Preferences"
            case .reset:
                nil
            }
        }
    }
}

extension SettingAppearance {
    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
