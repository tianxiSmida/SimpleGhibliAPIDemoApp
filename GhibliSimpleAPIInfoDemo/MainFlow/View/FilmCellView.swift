//
//  FilmCellView.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/19.
//

import RxSwift
import Kingfisher

class FilmCellView: UITableViewCell {
    
    private let favoriteButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .systemRed)
        btn.setImage(.init(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)
        btn.setImage(.init(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        return btn
    }()
    private let banner: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let directLabel: UILabel = .init()
    private let releaseLabel: UILabel = .init()
    
    var vm: FilmCellViewModel! {
        didSet {
            bindData()
        }
    }
    
    private var disposeBag: DisposeBag = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .gray
    }
    
    private func setupUI() {
        contentView.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(5.za.scaleWidth).priority(.high)
            make.height.equalTo(150.za.scaleWidth)
            make.width.equalTo(100.za.scaleWidth)
        }
        banner.contentMode = .scaleAspectFit
        
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.za.scaleWidth)
            make.right.equalToSuperview().inset(20.za.scaleWidth)
            make.width.height.equalTo(20.za.scaleWidth)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(banner).inset(5.za.scaleWidth)
            make.left.equalTo(banner.snp.right).offset(5.za.scaleWidth)
            make.right.lessThanOrEqualTo(favoriteButton.snp.left).offset(-5.za.scaleWidth)
        }
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 20.za.scaleWidth, weight: .black)
        titleLabel.textColor = .label
        
        contentView.addSubview(directLabel)
        directLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5.za.scaleWidth)
            make.left.equalTo(titleLabel)
        }
        directLabel.textAlignment = .left
        directLabel.font = .systemFont(ofSize: 18.za.scaleWidth, weight: .medium)
        directLabel.textColor = .secondaryLabel
        
        contentView.addSubview(releaseLabel)
        releaseLabel.snp.makeConstraints { make in
            make.top.equalTo(directLabel.snp.bottom).offset(5.za.scaleWidth)
            make.left.equalTo(directLabel)
        }
        releaseLabel.textAlignment = .left
        releaseLabel.font = .systemFont(ofSize: 16.za.scaleWidth, weight: .medium)
        releaseLabel.textColor = .tertiaryLabel
    }
    
    private func bindData() {
        disposeBag = .init()
        
        let output = vm.transform(input: .init(tapFavorite: favoriteButton.rx.tap.mapToVoid()))
        output.isFavorite
            .do(onNext: { [weak favoriteButton] _ in
                favoriteButton?.imageView?.addSymbolEffect(.bounce)
            })
            .bind(to: favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        titleLabel.text = output.title
        directLabel.text = "Directed by \(output.director)"
        releaseLabel.text = "Released: \(output.releaseYear)"
        guard
            !output.image.isEmpty,
            let resourceURL = URL(string: output.image) else {
            banner.image = nil
            return
        }
        banner.kf.setImage(with: resourceURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
