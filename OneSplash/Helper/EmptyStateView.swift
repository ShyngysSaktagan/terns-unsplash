//
//  EmptyStateView.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/15/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit
import SnapKit

class EmptyStateView: UIView {
    
    let messageLabel    = TitleLabel(textAlignment: .center, fontSize: 16)
    let logoImageView   = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String, logoImage: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        logoImageView.image = UIImage(systemName: logoImage)
        configure()
    }
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(logoImageView)

        logoImageView.tintColor = .gray
        messageLabel.numberOfLines  = 3
        messageLabel.textColor      = .white
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(150)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom)
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(100)
        }
    }
}
