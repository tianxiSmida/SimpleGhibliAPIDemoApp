//
//  FilmListViewController.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/16.
//

import RxSwift
import RxRelay
import SnapKit

class FilmListViewController: UIViewController {

    private let vm: FilmListViewModel
    private let tableView: UITableView = .init(frame: .zero, style: .grouped)
    
    private let tapCellSubject: PublishRelay<FilmCellViewModel> = .init()
    private let disposeBag = DisposeBag()
    private let cellType = FilmCellView.self
    
    init(vm: FilmListViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Ghibli Movies"
        setupUI()
        bindData()
    }
    
    // MARK: UI
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        tableView.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
    
    // MARK: Data & Action
    private func bindData() {
        let output = vm.transform(input: .init(didSelected: tapCellSubject.asObservable()))
        // 資料綁定
        output.films.drive(
            tableView.rx.items(
                cellIdentifier: String(describing: cellType),
                cellType: cellType)
        ) { index, element, cell in
            cell.vm = element
        }
        .disposed(by: disposeBag)
        // 點擊事件
        tableView.rx.modelSelected(FilmCellViewModel.self)
            .bind(to: tapCellSubject)
            .disposed(by: disposeBag)
    }
}
