//
//  PeopleListView.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/23.
//

import RxSwift
import RxCocoa
import SnapKit

class PeopleListView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    private let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .equalSpacing
        v.spacing = 3.za.scaleWidth
        return v
    }()
    
    private let edgeToSuperView: CGFloat = 5.za.scaleWidth
    private let dataSource: Observable<[Person]>
    private let isLoading: Observable<Bool>
    private let disposeBag = DisposeBag()
    
    init(people: Observable<[Person]>, isLoading: Observable<Bool>) {
        self.dataSource = people
        self.isLoading = isLoading
        super.init(frame: .zero)
        setupUI()
        bindData()
    }
    
    private func setupUI() {
        setupBackground()
        setupTitle()
        setupStackView()
    }
    
    private func bindData() {
        subscribeDataSource()
        subscribeLoading()
    }
    
    private func subscribeDataSource() {
        self.dataSource
            .observe(on: MainScheduler())
            .subscribe(onNext: setupSubViewFromDataSource)
            .disposed(by: disposeBag)
    }
    
    private func subscribeLoading() {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        self.isLoading
            .distinctUntilChanged()
            .observe(on: MainScheduler())
            .subscribe(onNext: { [unowned self] isLoading in
                if !isLoading {
                    indicatorView.removeFromSuperview()
                    return
                }
                self.addSubview(indicatorView)
                indicatorView.startAnimating()
                indicatorView.snp.makeConstraints { make in
                    make.top.bottom.equalTo(self.titleLabel)
                    make.left.equalTo(self.titleLabel.snp.right).offset(5.za.scaleWidth)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSubViewFromDataSource(_ people: [Person]) {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        for person in people {
            let personView = PersonView(model: person)
            stackView.addArrangedSubview(personView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PeopleListView {
    func setupBackground() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10.za.scaleWidth
    }
    func setupTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(edgeToSuperView)
            make.right.lessThanOrEqualToSuperview().inset(edgeToSuperView)
            make.height.equalTo(24.za.scaleWidth)
        }
    }
    func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(edgeToSuperView)
            make.left.right.bottom.equalToSuperview().inset(edgeToSuperView)
        }
    }
}
