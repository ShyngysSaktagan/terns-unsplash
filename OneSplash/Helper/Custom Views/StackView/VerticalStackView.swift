//
//  VerticalStackView.swift
//  OneSplash
//
//  Created by Shyngys Saktagan on 8/12/20.
//  Copyright © 2020 Terns. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(title: UILabel, subTitle: UILabel) {
        super.init(frame: .zero)
        addArrangedSubview(title)
        addArrangedSubview(subTitle)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        axis            = .vertical
        alignment       = .leading
        distribution    = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false
    }
}
