//
//  FilmDetailViewController.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/22.
//

import RxSwift
import RxCocoa
import SnapKit

class FilmDetailViewController: UIViewController {
    
    private let vm: FilmDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let favoriteButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemRed)
        btn.setImage(.init(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)
        btn.setImage(.init(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        return btn
    }()
    
    // -- UI --
    private let basedScrollView = {
        let v = UIScrollView()
        return v
    }()
    private let bannerImageView = UIImageView()
    private let titleLabel = UILabel()
    private let itemTitleStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        sv.spacing = 4.za.scaleWidth
        return sv
    }()
    private let itemInfoStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        sv.spacing = 4.za.scaleWidth
        return sv
    }()
    private lazy var sepratorLineOnDesc: UIView = createSeperatorLine()
    private lazy var descriptionTitleLabel = createLable(str: "Description",
                                                         font: .systemFont(ofSize: 16, weight: .semibold),
                                                         textColor: .black)
    private lazy var descriptionInfoLabel = createLable(str: "",
                                                        font: .systemFont(ofSize: 16, weight: .regular),
                                                        textColor: .black)
    private lazy var sepratorLineBelowDesc: UIView = createSeperatorLine()
    
    private let edgeOfSubView: CGFloat = 10.za.scaleWidth
    
    init(vm: FilmDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupUI() {
        setupFavoriteButton()
        setupScrollView()
        setupBanner()
        setupTitle()
        setupItemTitleStackView()
        setupItemInfoStackView()
        setupSepratorLineOnDesc()
        setupDescriptionInfo()
        setupSepratorLineBelowDesc()
    }
    
    private func bindData() {
        let output = vm.transform(input: .init(tapFavorite: favoriteButton.rx.tap.mapToVoid()))
        
        output.isFavorite
            .bind(to: favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        if let bannerURL = URL(string: output.bannerImage) {
            bannerImageView.kf.setImage(with: bannerURL, placeholder: UIImage(systemName: "photo.artframe"))
        }
        titleLabel.text = output.title
        setupItemInfo(director: output.director,
                      producer: output.producer,
                      releaseDate: output.releaseYear,
                      runningTime: output.duration + " minutes",
                      score: output.score + "/100")
        descriptionInfoLabel.text = output.description
        
        setupPeopleListView(people: output.people, isLoading: output.isLoading)
    }
    
    private func setupItemInfo(director: String, producer: String, releaseDate: String, runningTime: String, score: String) {
        let font = UIFont.systemFont(ofSize: 16.za.scaleWidth, weight: .regular)
        let color = UIColor.black
        
        let directorInfo = createLable(str: director, font: font, textColor: color)
        let producerInfo = createLable(str: producer, font: font, textColor: color)
        let releaseDateInfo = createLable(str: releaseDate, font: font, textColor: color)
        let runningTimeInfo = createLable(str: runningTime, font: font, textColor: color)
        let scoreInfo = createLable(str: score, font: font, textColor: color)
        itemInfoStackView.addArrangedSubview(directorInfo)
        itemInfoStackView.addArrangedSubview(producerInfo)
        itemInfoStackView.addArrangedSubview(releaseDateInfo)
        itemInfoStackView.addArrangedSubview(runningTimeInfo)
        itemInfoStackView.addArrangedSubview(scoreInfo)
    }
}

private extension FilmDetailViewController {
    func setupFavoriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    func setupScrollView() {
        view.addSubview(basedScrollView)
        basedScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
    }
    
    func setupBanner() {
        basedScrollView.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints { make in
            make.left.right.equalTo(basedScrollView)
            make.top.equalTo(basedScrollView)
            make.height.lessThanOrEqualTo(300.za.scaleWidth)
        }
        bannerImageView.contentMode = .scaleAspectFill
    }
    
    func setupTitle() {
        basedScrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(edgeOfSubView)
            make.left.right.equalToSuperview().inset(10.za.scaleWidth)
            make.height.equalTo(48.za.scaleWidth)
        }
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 32.za.scaleWidth, weight: .bold)
        titleLabel.textColor = .black
    }
    
    func setupItemTitleStackView() {
        basedScrollView.addSubview(itemTitleStackView)
        itemTitleStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.za.scaleWidth)
            make.left.equalTo(titleLabel)
        }
        let font = UIFont.systemFont(ofSize: 16.za.scaleWidth, weight: .medium)
        let color = UIColor.black
        
        let directorTitle = createLable(str: "Direct", font: font, textColor: color)
        let producerTitle = createLable(str: "Producer", font: font, textColor: color)
        let releaseDateTitle = createLable(str: "Release Date", font: font, textColor: color)
        let runningTimeTitle = createLable(str: "Running Time", font: font, textColor: color)
        let scoreTitle = createLable(str: "Score", font: font, textColor: color)
        itemTitleStackView.addArrangedSubview(directorTitle)
        itemTitleStackView.addArrangedSubview(producerTitle)
        itemTitleStackView.addArrangedSubview(releaseDateTitle)
        itemTitleStackView.addArrangedSubview(runningTimeTitle)
        itemTitleStackView.addArrangedSubview(scoreTitle)
    }
    
    func setupItemInfoStackView() {
        basedScrollView.addSubview(itemInfoStackView)
        itemInfoStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(itemTitleStackView)
            make.left.equalTo(itemTitleStackView.snp.right).offset(10.za.scaleWidth)
            make.right.lessThanOrEqualToSuperview().inset(16.za.scaleWidth)
        }
    }
    
    func setupSepratorLineOnDesc() {
        basedScrollView.addSubview(sepratorLineOnDesc)
        sepratorLineOnDesc.snp.makeConstraints { make in
            make.top.equalTo(itemTitleStackView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(edgeOfSubView)
            make.height.equalTo(1)
        }
    }
    
    func setupDescriptionInfo() {
        basedScrollView.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.numberOfLines = 0
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sepratorLineOnDesc.snp.bottom).offset(10.za.scaleWidth)
            make.left.right.equalToSuperview().inset(edgeOfSubView)
            make.width.lessThanOrEqualTo(view).inset(edgeOfSubView)
        }
        basedScrollView.addSubview(descriptionInfoLabel)
        descriptionInfoLabel.numberOfLines = 0
        descriptionInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(10.za.scaleWidth)
            make.left.right.equalToSuperview().inset(edgeOfSubView)
            make.width.lessThanOrEqualTo(view).inset(edgeOfSubView)
        }
    }
    
    func setupSepratorLineBelowDesc() {
        basedScrollView.addSubview(sepratorLineBelowDesc)
        sepratorLineBelowDesc.snp.makeConstraints { make in
            make.top.equalTo(descriptionInfoLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(edgeOfSubView)
            make.height.equalTo(1)
        }
    }
    
    func createLable(str: String, font: UIFont, textColor: UIColor) -> UILabel {
        let title = UILabel()
        title.text = str
        title.textAlignment = .left
        title.font = font
        title.textColor = textColor
        return title
    }
    
    func createSeperatorLine() -> UIView {
        let v = UIView()
        v.backgroundColor = .systemGray4
        return v
    }
    
    func setupPeopleListView(people: Observable<[Person]>, isLoading: Observable<Bool>) {
        let peopleView = PeopleListView(people: people, isLoading: isLoading)
        basedScrollView.addSubview(peopleView)
        peopleView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(edgeOfSubView)
            make.top.equalTo(sepratorLineBelowDesc.snp.bottom).offset(edgeOfSubView)
        }
    }
}
