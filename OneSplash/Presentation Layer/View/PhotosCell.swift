//
//  PhotoCell.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/6/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class PhotosCell: UITableViewCell {

    let photoView = UIImageView()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(16)
        }
    }
}
