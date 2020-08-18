//
//  UserCell.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/16/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class UserCell: UITableViewCell {
    
    var item: User? {
        didSet {
            profileImage.load(urlString: item?.profileImage?.medium ?? "")
            nameLabel.text = item?.name
            usernameLabel.text = item?.username
        }
    }
    
    let profileImage    = UIImageView(cornerRadius: 15)
    let usernameLabel   = TitleLabel(textAlignment: .left, fontSize: 18, weight: .bold, text: "username", color: .white)
    let nameLabel       = TitleLabel(textAlignment: .left, fontSize: 13, weight: .medium, text: "name", color: .gray)
    lazy var stackView  = VerticalStackView(title: usernameLabel, subTitle: nameLabel)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [profileImage, stackView].forEach { addSubview($0) }
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(75)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(25)
            make.centerY.equalTo(profileImage.snp.centerY)
        }
        configure() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
