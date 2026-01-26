//
//  PersonView.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/23.
//

import UIKit

class PersonView: UIView {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(16.za.scaleWidth)
        label.numberOfLines = 0
        return label
    }()
    
    let genderAndAgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).withSize(12.za.scaleWidth)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    let eyesAndHairLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).withSize(12.za.scaleWidth)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let edgeToSuperView: CGFloat = 5.za.scaleWidth
    
    var model: Person
    
    init(model: Person) {
        self.model = model
        super.init(frame: .zero)
        setupUI()
        setupData()
    }
    
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(edgeToSuperView)
            make.right.lessThanOrEqualToSuperview().inset(edgeToSuperView)
            make.height.equalTo(20.za.scaleWidth)
        }
        
        addSubview(genderAndAgeLabel)
        genderAndAgeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2.za.scaleWidth)
            make.height.equalTo(14.za.scaleWidth)
            make.bottom.equalToSuperview().inset(edgeToSuperView)
        }
        
        addSubview(eyesAndHairLabel)
        eyesAndHairLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(genderAndAgeLabel)
            make.right.equalToSuperview().inset(edgeToSuperView)
            make.left.greaterThanOrEqualTo(genderAndAgeLabel.snp.right)
        }
    }
    
    func setupData() {
        nameLabel.text = model.name
        genderAndAgeLabel.attributedText = createGenderAndAgeAttachment(gender: model.gender, age: model.gender)
        eyesAndHairLabel.attributedText = createEyesAndHairAttachment(eyesColor: model.eyeColor, hairColor: model.hairColor)
    }
    
    private func createGenderAndAgeAttachment(gender: String, age: String) -> NSAttributedString {
        let genderImg = NSTextAttachment()
        genderImg.image = UIImage(systemName: "person.fill")?.withTintColor(.secondaryLabel)
        genderImg.bounds = CGRect(x: 0, y: 0, width: genderAndAgeLabel.font.pointSize, height: genderAndAgeLabel.font.pointSize)
        let finalString = NSMutableAttributedString(attachment: genderImg)
        finalString.append(NSAttributedString(string: " \(gender)"))
        finalString.append(NSAttributedString(string: "  Age: \(age)"))
        return finalString
    }
    
    private func createEyesAndHairAttachment(eyesColor: String, hairColor: String) -> NSAttributedString {
        let eyesImg = NSTextAttachment()
        eyesImg.image = UIImage(systemName: "eye")?.withTintColor(.secondaryLabel)
        eyesImg.bounds = CGRect(x: 0, y: -1.za.scaleWidth, width: eyesAndHairLabel.font.pointSize * 1.1, height: eyesAndHairLabel.font.pointSize * 0.8)
        let finalString = NSMutableAttributedString(attachment: eyesImg)
        finalString.append(NSAttributedString(string: " \(eyesColor)"))
        finalString.append(NSAttributedString(string: "  Hair: \(hairColor)"))
        return finalString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
